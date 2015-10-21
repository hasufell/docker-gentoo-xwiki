FROM       hasufell/gentoo-tomcat:latest
MAINTAINER Julian Ospald <hasufell@gentoo.org>

ENV XWIKI_VER=7.0
ENV MYSQL_CONNECTOR_VER=5.1.35

##### PACKAGE INSTALLATION #####

# copy paludis config
COPY ./config/paludis /etc/paludis

# update world with our USE flags
RUN chgrp paludisbuild /dev/tty && cave resolve -c world -x

# install tools set
RUN chgrp paludisbuild /dev/tty && cave resolve -c tools -x

# update etc files... hope this doesn't screw up
RUN etc-update --automode -5

################################


RUN mkdir -p /xwiki/tomcat/webapps

# install xwiki
RUN wget -P /tmp \
	http://download.forge.ow2.org/xwiki/xwiki-enterprise-web-${XWIKI_VER}.war && \
	unzip -d /xwiki/tomcat/webapps/xwiki /tmp/xwiki-enterprise-web-${XWIKI_VER}.war && \
	wget -P /xwiki/tomcat/webapps/xwiki/WEB-INF/lib http://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VER}/mysql-connector-java-${MYSQL_CONNECTOR_VER}.jar
COPY ./config/xwiki/hibernate.cfg.xml \
	/xwiki/tomcat/webapps/xwiki/WEB-INF/hibernate.cfg.xml
COPY ./config/xwiki/xwiki.properties \
	/xwiki/tomcat/webapps/xwiki/WEB-INF/xwiki.properties

EXPOSE 8080

COPY start_xwiki.sh /start_xwiki.sh
RUN chmod +x /start_xwiki.sh

CMD /start_xwiki.sh
