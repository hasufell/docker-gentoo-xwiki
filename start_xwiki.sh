#!/bin/bash

die() {
	echo "$@"
	exit 1
}

if [[ ! -e /var/lib/xwiki ]] ; then
	mkdir -p /var/lib/xwiki || die
fi
chown tomcat:tomcat /var/lib/xwiki || die

if [[ ! -e /var/lib/tomcat-${TOMCAT_VER}/bin ]] ; then
	mkdir -p /var/lib/tomcat-${TOMCAT_VER}/bin || die
fi
chown tomcat:tomcat /var/lib/tomcat-${TOMCAT_VER}/bin || die

if [[ ! -e /var/lib/tomcat-${TOMCAT_VER}/webapps/xwiki ]] ; then
	mkdir -p /var/lib/tomcat-${TOMCAT_VER}/webapps || die
	cp -a /xwiki/tomcat/webapps/xwiki \
		/var/lib/tomcat-${TOMCAT_VER}/webapps/xwiki \
		|| die
fi


if [[ ${XWIKI_MYSQL_PW} ]] ; then
	sed -i \
		-e "/connection.password/s|>.*</property>|>${XWIKI_MYSQL_PW}</property>|" \
		/var/lib/tomcat-${TOMCAT_VER}/webapps/xwiki/WEB-INF/hibernate.cfg.xml \
		|| die
fi


exec /usr/share/tomcat-${TOMCAT_VER}/bin/catalina.sh run
