FROM postgres:9.6-alpine

RUN apk add --update rsync openssh

COPY ./setup-master.sh /docker-entrypoint-initdb.d/setup-master.sh
COPY .ssh /var/lib/postgresql/.ssh
RUN chown  postgres:postgres -R /var/lib/postgresql/.ssh
RUN chmod 400 /var/lib/postgresql/.ssh/id_rsa
RUN chmod 0666 /docker-entrypoint-initdb.d/setup-master.sh
RUN mkdir -p /var/lib/postgresql/data/mnt/server/archivedir
