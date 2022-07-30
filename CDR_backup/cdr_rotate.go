package main

import (
	"archive/zip"
	"database/sql"
	"encoding/csv"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
	_ "github.com/go-sql-driver/mysql"
	"github.com/sirupsen/logrus"
	"log"
	"os"
	"reflect"
	"runtime"
	"time"
)

var (
	MYSQLCONNECTSTRING string
	LOGFILE            string
	fileLog            *os.File
	Logger2File        *logrus.Logger
	LogR               *logrus.Entry
	db                 *DB
)

type DB struct {
	Connect *sql.DB
}

type CDR struct {
	CdrID         int64     `json:"cdr_id" gorm:"column:cdr_id"`
	SrcUsername   string    `json:"src_username" gorm:"column:src_username"`
	SrcDomain     string    `json:"src_domain" gorm:"column:src_domain"`
	DstUsername   string    `json:"dst_username" gorm:"column:dst_username"`
	DstDomain     string    `json:"dst_domain" gorm:"column:dst_domain"`
	DstOusername  string    `json:"dst_ousername" gorm:"column:dst_ousername"`
	CallStartTime time.Time `json:"call_start_time" gorm:"column:call_start_time"`
	Duration      uint      `json:"duration" gorm:"column:duration"`
	SipCallID     string    `json:"sip_call_id" gorm:"column:sip_call_id"`
	SipFromTag    string    `json:"sip_from_tag" gorm:"column:sip_from_tag"`
	SipToTag      string    `json:"sip_to_tag" gorm:"column:sip_to_tag"`
	SrcIp         string    `json:"src_ip" gorm:"column:src_ip"`
	Cost          int       `json:"cost" gorm:"column:cost"`
	Rated         int       `json:"rated" gorm:"column:rated"`
	Created       time.Time `json:"created" gorm:"column:created"`
}

func init() {
	if DEVENV := os.Getenv("DEVENV"); DEVENV == "true" {
		LOGFILE = os.Stdout.Name()
	} else {
		if LOGFILE = os.Getenv("CDRROTATE_LOG"); DEVENV == "" {
			LOGFILE = "/var/log/syslog"
		}
	}

	fileLog, err := os.OpenFile(LOGFILE, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
	if err != nil {
		log.Println("Cannot open file for logging: ", LOGFILE)
	}

	Logger2File = logrus.New()
	Logger2File.SetFormatter(&logrus.TextFormatter{
		DisableColors: true,
		FullTimestamp: true,
	})
	Logger2File.SetOutput(fileLog)

	//init database
	db_user := os.Getenv("DB_USER")
	db_password := os.Getenv("DB_PASS")
	db_host := "localhost"
	db_port := "3306"
	db_name := "kamailio"
	db_tz := "Local"
	if db_name == "" || db_user == "" {
		Logger2File.Error("DB_USER or DB_NAME is not set")
		os.Exit(1)
	}
	MYSQLCONNECTSTRING = fmt.Sprintf("%v:%v@tcp(%v:%v)/%v?parseTime=true&loc=%v", db_user, db_password, db_host, db_port, db_name, db_tz)
	db = initDB(MYSQLCONNECTSTRING)
}

func main() {
	db := initDB(MYSQLCONNECTSTRING)
	defer db.Connect.Close()
	startDate, endDate := time.Now().AddDate(0, 0, -1), time.Now()
	cdrs := db.SelectCDRs(startDate, endDate)

	fileName := fmt.Sprintf("cdr_from_%v_to_%v_sql", startDate.Format("20060102_150405"), endDate.Format("20060102_150405"))
	createZipFile(cdrs, fileName)

	err := uploadToS3(fileName)
	checkErr(err, true)

	//db.DeleteCDRs(cdrs)

}

func createZipFile(cdrs []CDR, fileName string) {

	archiveFile, err := os.Create(fileName + ".zip")
	checkErr(err, false)
	defer archiveFile.Close()

	zipWriter := zip.NewWriter(archiveFile)
	writer, err := zipWriter.Create(fileName + ".sql")
	checkErr(err, false)

	w := csv.NewWriter(writer)

	header := getHeader(cdrs[0])
	err = w.Write(header)
	checkErr(err, false)

	for _, c := range cdrs {
		err := w.Write(getStringFromStruct(c))
		checkErr(err, false)
		w.Flush()
	}

	err = zipWriter.Flush()
	checkErr(err, false)

	err = zipWriter.Close()
	checkErr(err, false)

}

func getHeader(cdr CDR) (header []string) {
	e := reflect.ValueOf(&cdr).Elem()
	for i := 0; i < e.NumField(); i++ {
		varName := e.Type().Field(i).Name
		header = append(header, varName)
	}
	return header
}

func getStringFromStruct(cdr CDR) (strArr []string) {
	e := reflect.ValueOf(&cdr).Elem()
	for i := 0; i < e.NumField(); i++ {
		varValue := e.Field(i).Interface()
		strVarValue := fmt.Sprintf("%v", varValue)
		strArr = append(strArr, strVarValue)
	}
	return strArr
}

func uploadToS3(filename, myBucket, myKey string) error {
	//upload to s3
	// The session the S3 Uploader will use
	sess := session.Must(session.NewSession())

	// Create an uploader with the session and default options
	uploader := s3manager.NewUploader(sess)

	f, err := os.Open(filename)
	if err != nil {
		return fmt.Errorf("failed to open file %q, %v", filename, err)
	}

	// Upload the file to S3.
	result, err := uploader.Upload(&s3manager.UploadInput{
		Bucket: aws.String(myBucket),
		Key:    aws.String(myKey),
		Body:   f,
	})
	if err != nil {
		return fmt.Errorf("failed to upload file, %v", err)
	}
	msg := fmt.Sprintf("file uploaded to, %s\n", result.Location)
	Logger2File.WithField("module", fn).WithField("info", err.Error()).WithField("line", line)
	Logger2File.Error(err.Error())
	return nil

}

func initDB(connectString string) *DB {
	database := &DB{}
	Db, err := sql.Open("mysql", connectString)
	checkErr(err, true)
	database.Connect = Db
	return database
}

func checkErr(err error, fatal bool) {
	if err != nil {
		_, fn, line, _ := runtime.Caller(1)
		Logger2File.WithField("module", fn).WithField("error", err.Error()).WithField("line", line)
		Logger2File.Error(err.Error())
		if fatal {
			os.Exit(1)
		}
	}
}

func (db *DB) SelectCDRs(start, end time.Time) (cdrs []CDR) {
	stmt, err := db.Connect.Prepare(`SELECT cdr_id,
       src_username,
       src_domain,
       dst_username,
       dst_domain,
       dst_ousername,
       call_start_time,
       duration,
       sip_call_id,
       sip_from_tag,
       sip_to_tag,
       src_ip,
       cost,
       rated,
       created
from cdrs
where call_start_time > ?
  and call_start_time < ? limit 2
`)
	checkErr(err, false)

	rows, err := stmt.Query(start, end)
	checkErr(err, false)

	columns, err := rows.Columns()
	checkErr(err, false)

	if len(columns) == 0 {
		return cdrs
	}

	for rows.Next() {
		var cdr CDR
		err = rows.Scan(&cdr.CdrID, &cdr.SrcUsername, &cdr.SrcDomain, &cdr.DstUsername, &cdr.DstDomain, &cdr.DstOusername, &cdr.CallStartTime, &cdr.Duration, &cdr.SipCallID, &cdr.SipFromTag, &cdr.SipToTag, &cdr.SrcIp, &cdr.Cost, &cdr.Rated, &cdr.Created)
		checkErr(err, false)
		cdrs = append(cdrs, cdr)
	}

	return cdrs
}

func (db *DB) DeleteCDRs(cdrs []CDR) {
	var listOfIDs string

	for _, c := range cdrs {
		listOfIDs += fmt.Sprintf("%v,", c.CdrID)
	}
	listOfIDs = listOfIDs[:len(listOfIDs)-1]

	fmt.Println(listOfIDs)
	//stmt, err := db.Connect.Prepare(`DELETE FROM cdrs WHERE cdr_id in ?`)
	//checkErr(err, false)

	//_ = stmt.QueryRow(listOfIDs)
}
