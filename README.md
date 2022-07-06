# Kamailio-STIR/SHAKEN setup

##### project name: kamailio-stirshaken-A003

<br>


This project installs kamailio with STIR/SHAKEN module secsipidx from asipto.
https://github.com/asipto/secsipidx

It creates EC2 instance with installed MySQL, Kamailio, Siremis and secsipidx module from asipto. During the first run it will request the certificate from Transnexus (STI-PA). 
You must be FCC registered and have valid token from iconectiv to get a certificate. If you do not know what it is: [https://transnexus.com/shaken-info-hub/](https://transnexus.com/shaken-info-hub/)


#### API mock for transnexus
https://38155eda-a57e-430a-b8d1-9441e91180d3.mock.pstmn.io


## Cloudformation script parameters:
* CertificateAuthorityToken - **MUST BE UPDATED**. A token from iconectiv. (Service Provider Code (SPC) token received from the STI-PA) (https://ca.transnexus.com/api-documentation https://transnexus.com/sti-ca/)  
* DBPassword - **default**.
* CertificateProviderURL - **default**.  https://api.ca.transnexus.com/certificates/request  
* HTTPLocation - **MUST BE UPDATED**. Your IP address from which you will login to the server
* InstanceType - t2.micro as default. Set to whatever you need
* KeyName - **MUST BE UPDATED**. The name of an existing EC2 KeyPair to enable SSH access to the instance
* PrivateKeyPath - **default**. Path to ssh private key. Used to generate STIR/SHAKEN certificate. The key will be generated automatically.
* PublicIPAddress - **MUST BE UPDATED**.  Elastic IP address which should be assigned to the instance. It was intentionally designed to be set manually, so if you recreate the stack you can use the same IP address
* RepoAddressKamailio - **default**. Address of this repository. Configuration files from conf/ folder will be copied
* RepoAddressSecsipid - **default**. Address of repository from where the source code for stir-shaken kamailio module should be downloaded
* SIPSignallingLocation - **MUST BE UPDATED**. The IP address range that is is allowed for signalling SIP traffic
* SIPSignallingLocation2 - **MUST BE UPDATED**. The IP address range that is is allowed for signalling SIP traffic
* SIPTerminatingLocation - **MUST BE UPDATED**. The IP address range that is is allowed for signalling SIP traffic. Note: this IP address will be used in kamailio config as terminator IP address
* SSHLocation - **MUST BE UPDATED**. The IP address range that can be used to SSH to the EC2 instance
* SSHLocation2 - **MUST BE UPDATED**. The IP address range that can be used to SSH to the EC2 instance
* STIRSHAKENcaCountry - **default**. Country for StirShaken certificate. The certificate will be requested from selected STI-CA
* STIRSHAKENcaDomain - **MUST BE UPDATED**. Domain for StirShaken certificate
* STIRSHAKENcaEmail - **MUST BE UPDATED**. Email for StirShaken certificate
* STIRSHAKENcaLocality - **MUST BE UPDATED**. Locality for StirShaken certificate
* STIRSHAKENcaOrgUnit - **MUST BE UPDATED**. Organization Unit for StirShaken certificate
* STIRSHAKENcaOrganization - **MUST BE UPDATED**. Organization for StirShaken certificate
* STIRSHAKENcaProvince - **MUST BE UPDATED**. Province for StirShaken certificate



## Helpful commands
kamcmd lcr.reload

### TODO
[ ] add CA URL to tags and set env vars from tags
[ ] test calls if instance down
[ ] implement cfn-hub to listen for template updates
[ ] Get certificate from transnexus  
[ ] Check $fU (from_number) agains database numbers  
[x] Install siremis  
[x] Generate proper "listen string with private/public IP address"  