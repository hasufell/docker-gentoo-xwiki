#!/bin/bash

die() {
	echo "$@"
	exit 1
}

tomcatdir="/var/lib/tomcat-${TOMCAT_VER}"
webappdir="${tomcatdir}/webapps"

if [[ ! -e /var/lib/xwiki ]] ; then
	mkdir -p /var/lib/xwiki || die
fi
chown tomcat:tomcat /var/lib/xwiki || die

if [[ ! -e "${tomcatdir}"/bin ]] ; then
	mkdir -p "${tomcatdir}"/bin || die
fi
chown tomcat:tomcat "${tomcatdir}"/bin || die

if [[ ! -e "${webappdir}"/.initialized ]] ; then
	mkdir -p "${webappdir}" || die
	rm -rf "${webappdir}"/ROOT
	cp -a /xwiki/tomcat/webapps/xwiki \
		"${webappdir}"/ROOT \
		|| die
	touch "${webappdir}"/.initialized || die
fi


if [[ ${XWIKI_MYSQL_PW} ]] ; then
	sed -i \
		-e "/connection.password/s|>.*</property>|>${XWIKI_MYSQL_PW}</property>|" \
		"${webappdir}"/ROOT/WEB-INF/hibernate.cfg.xml \
		|| die
fi


exec /usr/share/tomcat-${TOMCAT_VER}/bin/catalina.sh run
