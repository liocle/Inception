# ~/project/srcs/requirements/mariadb/Dockerfile
FROM alpine:3.19.1

RUN apk update; apk --no-cache add mariadb mariadb-client
# RUN apk --no-cache add openrc ## Needed?

COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/
RUN chmod 440 /etc/my.cnf.d/mariadb-server.cnf

COPY ./tools/entrypoint.sh .



EXPOSE 3306
CMD ["--user=mysql"]
