FROM alpine:3.6

MAINTAINER Antoine Cotten <tonio.cotten@gmail.com> (@antoineco)

ENV TD_VERSION 2.92-r5

RUN apk --no-cache add \
	transmission-daemon=${TD_VERSION} \
	su-exec

VOLUME ["/var/lib/transmission"]

COPY docker-entrypoint.sh /usr/local/bin

EXPOSE 9091 51413/tcp 51413/udp
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["transmission-daemon"]
