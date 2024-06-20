FROM alpine:3.19.1

################################################################################
## https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/
#
# Install prerequisites
RUN apk add openssl curl ca-certificates

########################################
# Set up the apk repository for stable nginx packages
WORKDIR /cert-build
RUN printf "%s%s%s\n" "http://nginx.org/packages/alpine/v" `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`  "/main" | tee -a /etc/apk/repositories
# Import an official nginx signing key so apk could verify the packages authenticity
RUN curl -o nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub
# Check the downloaded file contains the proper key
RUN openssl rsa -pubin -in nginx_signing.rsa.pub -text -noout > nginx_signing.rsa.pub_Modulus_obtained.log
# Move the key to apk trusted keys storage
RUN mv nginx_signing.rsa.pub /etc/apk/keys/

########################################
RUN openssl req -x509 -newkey rsa:4096 -keyout ${NGINX_HOST_DOMAIN}.key -out ${NGINX_HOST_DOMAIN}.crt -sha256 -days 365 -nodes -subj "/CN=${NGINX_HOST_DOMAIN}"

################################################################################
## https://wiki.alpinelinux.org/wiki/Nginx
# Install nginx 
RUN apk add nginx

# create new user and group for nginx
RUN adduser -D -g 'www' www

# Create a directory for html files
RUN mkdir /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www

# Backup of original nginx.conf file 
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig


# Expose port for HTTPS
EXPOSE 443


