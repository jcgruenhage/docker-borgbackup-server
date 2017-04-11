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
	borg-gen-auth-keys /backup/config/hosts.json > authorized_keys
	chown -R borg:borg .
	chmod 700 .
	chmod 700 ..
	chmod 600 authorized_keys
}

updateIDs
writeAuthKeys
ssh-keygen -A
exec /bin/s6-svscan /etc/s6.d
