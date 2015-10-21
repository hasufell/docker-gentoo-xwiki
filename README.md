First set up the mysql database:
```sh
docker run -ti -d \
	--name=xwiki-mysql \
	-v <host-folder>:/var/lib/mysql \
	-e MYSQL_PASS=<admin-pw> \
	hasufell/gentoo-mysql
docker exec -ti \
	xwiki-mysql \
	/bin/bash -c "mysql -u root -e \"create database xwiki default character set utf8 collate utf8_bin\" && mysql -u root -e \"grant all privileges on *.* to 'xwiki'@'%' identified by '<xwiki-mysql-pw>'\""
```

Then set up tomcat:
```sh
docker run -ti \
	-v <host-folder>:/var/lib/tomcat-8 \
	-v <host-folder>:/etc/tomcat-8 \
	hasufell/gentoo-xwiki \
	/usr/share/tomcat-8/gentoo/tomcat-instance-manager.bash --create
```

Then start the shit:
```sh
docker run -ti -d \
	--link xwiki-mysql:xwiki-mysql \
	-v <host-folder>:/var/lib/tomcat-8 \
	-v <host-folder>:/etc/tomcat-8 \
	-v <host-folder>:/var/lib/xwiki \
	-e XWIKI_MYSQL_PW=<xwiki-mysql-pw> \
	-p 8080:8080 \
	hasufell/gentoo-xwiki
```
