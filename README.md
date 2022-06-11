# Kamailio-STEIR/SHAKEN setup

project name: kamailio-stirshaken-A003
---------------------------- 

This project installs kamailio with STIR/SHAKEN module secsipidx from asipto.
https://github.com/asipto/secsipidx

It creates EC2 instance with MySQL and module. During the first run it will request the certificate from Transnexus. You must be FCC registered and have valid token from iconectiv. If you do not know what it is: [https://transnexus.com/shaken-info-hub/](https://transnexus.com/shaken-info-hub/)


#### API mock for transnexus
https://38155eda-a57e-430a-b8d1-9441e91180d3.mock.pstmn.io


## Cloudformation script parameters description
PublicIPAddress - elastic IP address. 



### TODO
[ ] add CA URL to tags and set env vars from tags
[ ] test calls if instance down
[ ] implement cfn-hub to listen for template updates
[ ] Get certificate from transnexus  
[ ] Check $fU (from_number) agains database numbers  
[x] Install siremis  
[x] Generate proper "listen string with private/public IP address"  