FROM alpine:3.19

# This docker file builds the NGINX container, installs necessary packages, generates SSL certificates, copies configuration files, and starts NGINX in the foreground.
# https://wiki.alpinelinux.org/wiki/Nginx

WORKDIR /


# Install prerequisites and nginx from Alpine repository
RUN apk add --no-cache \
        nginx \
        openssl

ARG NGINX_HOST_DOMAIN
ENV NGINX_HOST_DOMAIN=lclerc.42.fr
RUN if ! getent group nginx_system_user > /dev/null; then addgroup -S nginx_system_user; fi
RUN adduser -S nginx_system_user -G nginx_system_user
# Create a directory for HTML files and set permissions
RUN mkdir -p /www /etc/nginx/ssl \
            && chown -R nginx_system_user:nginx_system_user /var/lib/nginx /www

# Generate SSL certificates
# RUN openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/lclerc.42.fr.key -out /etc/nginx/ssl/lclerc.42.fr.crt -sha256 -days 365 -nodes -subj "/CN=lclerc.42.fr"
RUN openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes \
                -out /etc/nginx/ssl/certificate.crt \
                -keyout /etc/nginx/ssl/certificate.key \
                -subj "/C=FI/ST=Helsinki/L=Helsinki/O=42/OU=Hive/CN=lclerc.42.fr"

# Copy configuration files
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose port for HTTPS
EXPOSE 443
VOLUME /var/log/nginx

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

