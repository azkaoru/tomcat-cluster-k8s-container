#!/bin/bash
QUAY_USER=azkaoru
TOMCAT_VERSION=9.0.27
buildah umount tomcat${TOMCAT_VERSION}-java13
buildah rm tomcat${TOMCAT_VERSION}-java13
buildah umount quay.io/${QUAY_USER}/tomcat${TOMCAT_VERSION}-cluster-java13
buildah rm quay.io/${QUAY_USER}/tomcat${TOMCAT_VERSION}-cluster-java13

#
# create tomcat
#
buildah from --name tomcat${TOMCAT_VERSION}-java13  quay.io/${QUAY_USER}/fedora30-java13-devel
buildah config --env CATALINA_HOME=/opt/tomcat9 tomcat${TOMCAT_VERSION}-java13
buildah add tomcat${TOMCAT_VERSION}-java13 apache-tomcat-${TOMCAT_VERSION}.tar.gz /opt/
buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat9
buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/chmod -R ug+rwx /opt/tomcat9/
buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/cp /opt/tomcat9/conf/server.xml /opt/tomcat9/conf/server.xml.org
#valve setting
buildah add tomcat${TOMCAT_VERSION}-java13 conf/valve.xml /tmp/
buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/awk -i inplace '/\/Host/{while(getline line<"/tmp/valve.xml"){print line}} //' /opt/tomcat9/conf/server.xml
buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/rm /tmp/valve.xml
# java.io.FileNotFoundException: /proc/self/fd/1.2019-10-31 (No such file or directory) by podman
#buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/sed -i -e 's/directory="logs"/directory="\/proc\/self\/fd"/g' /opt/tomcat9/conf/server.xml
#buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/sed -i -e 's/prefix=\"localhost_access_log\"/prefix=\"1\"/g' /opt/tomcat9/conf/server.xml
#buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/sed -i -e 's/suffix=\".txt\"/suffix=\"\"/g' /opt/tomcat9/conf/server.xml
#logging setting
buildah add tomcat${TOMCAT_VERSION}-java13 conf/logging.properties /tmp/
buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/cp /tmp/logging.properties /opt/tomcat9/conf/logging.properties
buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/rm /tmp/logging.properties

#
#cluster setting
#
buildah add tomcat${TOMCAT_VERSION}-java13 conf/host_cluster.xml /tmp/
buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/awk -i inplace '/\SingleSignOn/{while(getline line<"/tmp/host_cluster.xml"){print line}} //' /opt/tomcat9/conf/server.xml
buildah run tomcat${TOMCAT_VERSION}-java13 /usr/bin/rm /tmp/host_cluster.xml

buildah config  --entrypoint  '["/opt/tomcat9/bin/catalina.sh", "run"]' --workingdir /opt/tomcat9  tomcat${TOMCAT_VERSION}-java13
buildah commit tomcat${TOMCAT_VERSION}-java13 quay.io/${QUAY_USER}/tomcat${TOMCAT_VERSION}-cluster-java13

