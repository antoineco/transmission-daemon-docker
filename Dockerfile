FROM alpine

MAINTAINER Antoine Cotten <tonio.cotten@gmail.com> (@antoineco)

RUN apk --no-cache add \
	transmission-daemon \
	su-exec

VOLUME ["/var/lib/transmission"]

COPY docker-entrypoint.sh /usr/local/bin

EXPOSE 9091 51413/tcp 51413/udp
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["transmission-daemon"]
