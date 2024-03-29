#!/bin/bash

# docker stop peeringhub; docker rm peeringhub; docker rmi peeringhub_img; docker build -t peeringhub_img . ; docker run -d --mount type=bind,source="$(pwd)",target=/app --name peeringhub peeringhub_img; docker exec -it peeringhub /bin/bash
./dnl_acme_client -c ./acme_client.conf gen_spc ./ec256-private.pem TEMPLATE_SPC_VALUE > ./TEMPLATE_SPC_VALUE.spc
if [[ ! -s TEMPLATE_SPC_VALUE.spc ]]; then
        echo "SPC token is empty. Exiting."
        exit 1
fi
./dnl_acme_client -c ./acme_client.conf --spc ./TEMPLATE_SPC_VALUE.spc new_order ./ec256-private.pem TEMPLATE_SPC_VALUE 0 0 C="TEMPLATE_COUNTRY_4_CSR" S="TEMPLATE_PROVINCE_4_CSR" L="TEMPLATE_LOCALITY_4_CSR" O="TEMPLATE_ORGANIZATION_4_CSR" CN="TEMPLATE_ORGANIZATION_4_CSR SHAKEN TEMPLATE_SPC_VALUE" 2>./error.log > TEMPLATE_SPC_VALUE.crt
if [[ $? -qe 1 ]]; then #might be cert already exists
        cat error.log  ##display to console
        exit 1
fi