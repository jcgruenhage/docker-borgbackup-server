FROM alpine:edge

MAINTAINER	Jan Christian Grünhage <me@jcg.re>

ENV UID 192 
ENV GID 192
ENV GOPATH /tmp/gopath

RUN	apk add --update \
		borgbackup \
		su-exec \
		go \
		ca-certificates \
		build-base \
		git \
		openssh \
		bash \
		nano \
		shadow \
		s6 \
	&& mkdir /tmp/gopath \
	&& mkdir -p /backup/config \
	&& mkdir -p /backup/storage \
	&& mkdir -p /home/borg \
	&& go get git.jcg.re/jcgruenhage/borg-gen-auth-keys.git \
	&& apk del --purge \
		go \
		build-base \
		git \
	&& mv $GOPATH/bin/borg-gen-auth-keys.git /usr/local/bin/borg-gen-auth-keys \
	&& rm -rf \
		/tmp \
		/var/cache/apk/* \
		/usr/lib/python3.6/__pycache__ \
	&& addgroup -g $GID -S borg \
	&& adduser -S -u $UID -g $GID -h /home/borg borg \
	&& usermod -p "*" borg \
	&& usermod -s /bin/bash borg \
	&& passwd -u borg

ADD	root /
VOLUME	/backup/storage
VOLUME	/backup/config
EXPOSE	22

CMD	["/usr/local/bin/run.sh"]
