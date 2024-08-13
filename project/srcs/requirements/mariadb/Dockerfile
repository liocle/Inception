#  # ~/project/srcs/requirements/mariadb/Dockerfile
#  FROM alpine:3.19.1
#  
#  RUN apk add --no-cache mariadb mariadb-client && \
#      mkdir -p /run/mysqld /var/lib/mysql /var/log/mysql /data/mariadb && \
#      chown -R mysql:mysql /run/mysqld /var/lib/mysql /var/log/mysql /data/mariadb
#  EXPOSE 3306
#  
#  COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/
#  RUN chmod 777 /etc/my.cnf.d/mariadb-server.cnf
#  
#  COPY ./tools/entrypoint.sh .
#  RUN chmod +x entrypoint.sh
#  
#  ENTRYPOINT ["sh", "entrypoint.sh"]
#  
#  CMD ["mysqld_safe]

FROM alpine:3.18

RUN apk update && apk add mariadb mariadb-client

COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
RUN chmod 440 /etc/my.cnf.d/mariadb-server.cnf

COPY ./tools/entrypoint.sh /
RUN chmod +x entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["sh", "entrypoint.sh"]
