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
	        aeron_cmd_stat $aeron_install_retval $machine install_fn_chrony
		
		if [ "$machine" == "Ubuntu" ];then
	            sudo apt-get install software-properties-common -y
        	    sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
            	sudo cp $TOP_DIR/etc/mariadb.list /etc/apt/sources.list.d/mariadb.list -v
            	sudo apt update -y
        	fi

		$PKG_TOOL install mariadb-server python-pymysql -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_mariadb
	
		$PKG_TOOL install rabbitmq-server -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_rabbit

		###initializing rabbitmq server
	        rabbitmqctl add_user openstack $RABBIT_PASSWORD
	        aeron_install_retval="$?"
	        aeron_cmd_stat $aeron_install_retval $machine install_fn_rabbit_useradd_openstack
	
	
	        rabbitmqctl set_permissions openstack ".*" ".*" ".*"
	        aeron_install_retval="$?"
	        aeron_cmd_stat $aeron_install_retval $machine install_fn_rabbit_set_permissions

		$PKG_TOOL install memcached python-memcache -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_memcached
	
		$PKG_TOOL install etcd -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_etcd

		$PKG_TOOL install keystone -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_keystone
	
		$PKG_TOOL install glance -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_glance

		$PKG_TOOL install placement-api -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_placement

		$PKG_TOOL install nova-api nova-conductor nova-novncproxy nova-scheduler -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_nova
	
		$PKG_TOOL install neutron-server neutron-plugin-ml2 \
  				neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent \
  				neutron-metadata-agent -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_neutron
		

		$PKG_TOOL install openstack-dashboard -y
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_openstack-dashboard

		if [ $1 = 'allinone' ]; then
			$PKG_TOOL install nova-compute -y
                	aeron_install_retval="$?"
                	aeron_cmd_stat $aeron_install_retval $machine install_fn_nova_compute
		fi
	fi
}


main () {

	echo "2nd arg of install $2"
	sleep 10s
	
	find_package_fn

	pip$PIP_VERSION -h
        aeron_install_retval="$?"
        if [ $aeron_install_retval != $SUCCESS ];then
                $PKG_TOOL install python$PIP_VERSION-pip
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine install_fn_pip

        fi
	
	install_fn $2
	return 0	
}
main $@
