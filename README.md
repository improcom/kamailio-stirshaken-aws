# Kamailio-STEIR/SHAKEN setup

project name: kamailio-stirshaken-A003
---------------------------- 

This project installs kamailio with STIR/SHAKEN module


### TODO
[ ] add CA URL to tags and set env vars from tags

[ ] test calls if instance down
[ ] implement cfn-hub to listen for template updates
[ ] Get certificate from transnexus  
[ ] Check $fU (from_number) agains database numbers  
[ ] Install seremius  
[ ] Generate proper "listen string with private/public IP address"  



#### API mock for transnexus
https://38155eda-a57e-430a-b8d1-9441e91180d3.mock.pstmn.io


## Cloudformation script parameters
PublicIPAddress - elastic IP address. 