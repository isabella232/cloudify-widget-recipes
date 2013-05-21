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

export PATH=$PATH:/usr/sbin:/sbin:/usr/bin || error_exit $? "Failed on: export PATH=$PATH:/usr/sbin:/sbin"

sudo service mysql start || error_exit $? "Failed on: sudo service mysql start"

ps -ef | grep -i mysql | grep -ivE "gigaspaces|GSC|GSA|grep"

TOMCAT_VERSION=apache-tomcat-7.0.23
TOMCAT_INSTALL_DIR=~/.cloudify/tomcat
TOMCAT_HOME=$TOMCAT_INSTALL_DIR/$TOMCAT_VERSION
cd $TOMCAT_HOME/bin
./catalina.sh run