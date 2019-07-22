FROM postgres:9.6-alpine

ENV GOSU_VERSION 1.10

ADD ./gosu /usr/bin/
RUN chmod +x /usr/bin/gosu

RUN apk add --update iputils
RUN apk add --update htop

COPY ./slave_setup.sh /slave_setup.sh

RUN chmod +x /slave_setup.sh

ENTRYPOINT ["/slave_setup.sh"]

CMD ["gosu", "postgres", "postgres"]
