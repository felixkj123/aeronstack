#!/bin/bash

. local.conf

TOP_DIR=$(cd $(dirname "$0") && pwd)

PKG_TOOL=""

SUCCESS=0
ERROR=1

check_machine() {
	retval=""
	machine=$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed "s/\"//g")
	if [ $machine = "Ubuntu" ]; then
		#echo "machine is $machine"
		retval=$machine
	fi
	echo $retval
}

aeron_cmd_stat () {
	echo -e "\e[1;32maeron_cmd_stat\e[0m"
	echo "aeron_cmd_stat is $1"

	if [ $1 != $SUCCESS  ]; then
		echo -e "\e[1;32mcmd failure...\e[0m"
		exit 1
	else
		echo "Done\n"
	
	fi
}

check_machine $mac
check_ret=$(check_machine )

#echo "f machine is <<$check_ret>>"

case $check_ret in
	"Ubuntu")
		PKG_TOOL="apt-get"
		;;
	"CentOS Linux")
		PKG_TOOL="yum"
		;;
	*)
		PKG_TOOL="error"
esac

if [ $NODE = 'controller'  ]; then
	$PKG_TOOL update
	aeron_install_retval="$?"
	aeron_cmd_stat $aeron_install_retval	


fi
