#!/bin/bash -x

TOMCAT_VERSION=apache-tomcat-7.0.23
TOMCAT_ZIP=$TOMCAT_VERSION.zip
TOMCAT_INSTALL_DIR=~/.cloudify/tomcat
TOMCAT_ZIP_URL=http://repository.cloudifysource.org/org/apache/tomcat/7.0.23/$TOMCAT_ZIP
TOMCAT_HOME=$TOMCAT_INSTALL_DIR/$TOMCAT_VERSION
TOMCAT_CONF=$TOMCAT_HOME/conf
TOMCAT_LOCAL=$TOMCAT_CONF/Catalina/localhost
TOMCAT_ROOT_XML=$TOMCAT_LOCAL/ROOT.xml
SERVER_XML=$TOMCAT_CONF/server.xml
CONTEXT_XML=$TOMCAT_CONF/context.xml
applicationWar="mysqladmin.war"
WAR_LOCAL_PATH=$TOMCAT_HOME/$applicationWar
MYSQLADMIN_WAR_URL=https://s3.amazonaws.com/cloudify-widget/$applicationWar
ORIG_UNPACK='unpackWARs="true"'
NEW_UNPACK='unpackWARs="false"'

dbName=$1
dbUser=$2 
dbPassW=$3

ORIG_SERVER_RESOURCE="</GlobalNamingResources>"
NEW_SERVER_RESOURCE="<Resource name=\"jdbc/mysqldb\" auth=\"Container\" factory=\"org.apache.tomcat.jdbc.pool.DataSourceFactory\" type=\"javax.sql.DataSource\" maxActive=\"100\" maxIdle=\"30\" maxWait=\"-1\" username=\"${dbUser}\" password=\"${dbPassW}\" driverClassName=\"com.mysql.jdbc.Driver\"  url=\"jdbc:mysql://localhost:3306/${dbName}\"/>	\n${ORIG_SERVER_RESOURCE}"

ORIG_CTX="<Context>"
NEW_CTX="${ORIG_CTX}\n<ResourceLink global=\"jdbc/mysqldb\" name=\"jdbc/mysqldb\" type=\"javax.sql.DataSource\"/>"

rm -rf $TOMCAT_INSTALL_DIR
rm -f $TOMCAT_ZIP

wget $TOMCAT_ZIP_URL
mkdir -p $TOMCAT_INSTALL_DIR
unzip $TOMCAT_ZIP -d $TOMCAT_INSTALL_DIR
cd $TOMCAT_HOME/
wget $MYSQLADMIN_WAR_URL

mkdir -p $TOMCAT_LOCAL
echo "<Context docBase=\"${WAR_LOCAL_PATH}\" />" > $TOMCAT_ROOT_XML
sed -i -e "s+$ORIG_UNPACK+$NEW_UNPACK+g" $SERVER_XML
sed -i -e "s+$ORIG_SERVER_RESOURCE+$NEW_SERVER_RESOURCE+g" $SERVER_XML

find / -name "mysql-connector*.jar" | grep usmlib | xargs -I file cp file $TOMCAT_HOME/lib/

sed -i -e "s+$ORIG_CTX+$NEW_CTX+g" $CONTEXT_XML

cd $TOMCAT_HOME/bin
chmod +x *.sh






 
