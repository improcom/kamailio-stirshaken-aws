# our base image
FROM redhat/ubi8
WORKDIR /app
#ADD . /app
RUN dnf install curl openssl libuuid -y
# run the application
CMD ["./get_spc_and_certificate_in_docker.sh"]