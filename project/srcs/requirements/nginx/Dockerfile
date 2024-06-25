FROM alpine:3.19

# This docker file builds the NGINX container, installs necessary packages, generates SSL certificates, copies configuration files, and starts NGINX in the foreground.
# https://wiki.alpinelinux.org/wiki/Nginx

# Install prerequisites and nginx from Alpine repository
RUN apk add --no-cache \
    nginx \
    openssl \
    curl \
    ca-certificates

# Create a directory for HTML files and set permissions
RUN mkdir -p /www /etc/nginx/certs \
    && chown -R nginx:nginx /var/lib/nginx /www

# Generate SSL certificates
RUN openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/certs/${NGINX_HOST_DOMAIN}.key -out /etc/nginx/certs/${NGINX_HOST_DOMAIN}.crt -sha256 -days 365 -nodes -subj "/CN=${NGINX_HOST_DOMAIN}"

# Copy configuration files
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/http.d/default.conf

# Expose port for HTTPS
EXPOSE 443

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

