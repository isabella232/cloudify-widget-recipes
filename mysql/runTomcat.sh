#!/bin/bash -x

# args:
# $1 the error code of the last command (should be explicitly passed)
# $2 the message to print in case of an error
# 
# an error message is printed and the script exists with the provided error code
function error_exit {
	echo "$2 : error code: $1"
	exit ${1}
}

function killMySqlProcess {
	ps -ef | grep -iE "catalina" | grep -ivE "install|gigaspaces|GSC|GSA|grep"
	if [ $? -eq 0 ] ; then 
		ps -ef | grep -iE "catalina" | grep -ivE "install|gigaspaces|GSC|GSA|grep" | awk '{print $2}' | xargs sudo kill -9
	fi  
}

export PATH=$PATH:/usr/sbin:/sbin:/usr/bin || error_exit $? "Failed on: export PATH=$PATH:/usr/sbin:/sbin"

echo "#1 Killing old tomcat process if exists..."
killMySqlProcess

TOMCAT_VERSION=apache-tomcat-7.0.23
TOMCAT_INSTALL_DIR=~/.cloudify/tomcat
TOMCAT_HOME=$TOMCAT_INSTALL_DIR/$TOMCAT_VERSION
cd $TOMCAT_HOME/bin
./catalina.sh run