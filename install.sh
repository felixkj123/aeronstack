#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)

PKG_TOOL=""

SUCCESS=0
ERROR=1

PIP_VERSION=3

machine=$(check_machine )

echo "the machine is <<$machine>>"

find_package_fn () {
	case $machine in
		"Ubuntu")
			PKG_TOOL="apt"
			;;
		"CentOS Linux")
			PKG_TOOL="yum"
			;;
		*)
			PKG_TOOL="error"
	esac
}

install_fn () {
	if [ $NODE = 'controller'  ]; then
		#echo $PKG_TOOL
		#$PKG_TOOL update
		#aeron_install_retval="$?"
		#aeron_cmd_stat $aeron_install_retval $machine
	
		$PKG_TOOL install chrony -y
	        aeron_install_retval="$?"
	        aeron_cmd_stat $aeron_install_retval $machine install_fn
		
		$PKG_TOOL install mariadb-server python-pymysql -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn
	
		$PKG_TOOL install rabbitmq-server -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn

		###initializing rabbitmq server
	        rabbitmqctl add_user openstack $RABBIT_PASSWORD
	        aeron_install_retval="$?"
	        aeron_cmd_stat $aeron_install_retval $machine install_fn
	
	
	        rabbitmqctl set_permissions openstack ".*" ".*" ".*"
	        aeron_install_retval="$?"
	        aeron_cmd_stat $aeron_install_retval $machine install_fn

		$PKG_TOOL install memcached python-memcache -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn
	
		$PKG_TOOL install etcd -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn

		$PKG_TOOL install keystone -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn
	
		$PKG_TOOL install glance -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn

		$PKG_TOOL install placement-api -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn

		$PKG_TOOL install nova-api nova-conductor nova-novncproxy nova-scheduler -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn
	fi
}


main () {
	pip$PIP_VERSION -h
	aeron_install_retval="$?"
	if [ $aeron_install_retval != $SUCCESS  ];then
		$PKG_TOOL install python$PIP_VERSION-pip
		aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_pip

	fi
	
	find_package_fn
	install_fn
	return 0	
}
main $@
