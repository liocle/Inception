# ~/project/srcs/requirements/mariadb/Dockerfile
FROM alpine:3.19.1

RUN apk update && apk --no-cache add mariadb mariadb-client

EXPOSE 3306

COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/
RUN chmod 440 /etc/my.cnf.d/mariadb-server.cnf

COPY ./tools/entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["sh", "entrypoint.sh"]
