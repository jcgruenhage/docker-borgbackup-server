## What is this?
This is a simple backup server for backing up multiple hosts to with [borgbackup](https://borgbackup.readthedocs.io/en/stable/index.html). 
It takes in requires config file in json format, that is used to generate the authorized_keys file, which is regenerated on every container startup. 

### Volumes
This container has three volumes:
 - ```/backup/config```, which should contain a file called ```hosts.json```, that contains the hosts allowed to connect to this server. For an example, look at the repo of the generation go script at https://git.jcg.re/jcgruenhage/borgocli. Please note, that the folder variable in the beginning must be set to the next volume:
 - ```/backup/storage```, where the actual backups will be located in.
 - ```/backup/keys```, where the host keys of the ssh daemon will be stored, so that replacing the container won't make it untrusted, because of changing keys.

### Ports
This container only listens on port 22, for SSH connections. Map that to some other host port, and connect to that with something like ```borg create ssh://borg@server:10022/backup/storage/client::archive1```, assuming that the hostname of your server is server, the clients hostname is client and you mapped port 22 to port 10022 on the server.
