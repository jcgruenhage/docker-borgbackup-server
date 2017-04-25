#!/bin/bash
function updateIDs {
	usermod -u $UID borg
	groupmod -g $GID borg
	usermod -g $GID borg 
	chown -R borg:borg /backup
}

function writeAuthKeys {
	mkdir -p /home/borg/.ssh/
	cd /home/borg/.ssh/
	borgocli generate authorized_keys /backup/config/hosts.json > authorized_keys
	chown -R borg:borg .
	chmod 700 .
	chmod 700 ..
	chmod 600 authorized_keys
}

function writeHostKeys {
	#Write existing host keys to /etc/ssh
	cd /backup/keys/
	for f in ssh_host_*; do
		cp -f $f /etc/ssh/
	done
	#Generate missing host keys
	ssh-keygen -A
	#Copy host keys to volume
	cd /etc/ssh/
	for f in ssh_host_*; do
		cp -f $f /backup/keys/
	done
}

updateIDs
writeAuthKeys
writeHostKeys
exec /bin/s6-svscan /etc/s6.d
