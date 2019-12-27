#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)


machine=$(check_machine )

services_enable_fn() {
	systemctl enable chrony
	aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_chrony

	systemctl enable mariadb
	aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_mariadb

	systemctl enable memcached
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_memcached

	systemctl enable etcd
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_etcd

	systemctl enable apache2
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_apache2

	systemctl enable glance-api
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_glance_api

	systemctl enable nova-api
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_nova-api

	systemctl enable nova-scheduler
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_nova-scheduler

	systemctl enable nova-conductor
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_nova-conductor

	systemctl enable nova-novncproxy
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_nova-novncproxy

	systemctl enable neutron-server
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_neutron-server

	systemctl enable neutron-linuxbridge-agent
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_neutron-linuxbridge-agent

	systemctl enable neutron-dhcp-agent
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_neutron-dhcp-agent

	systemctl enable neutron-metadata-agent
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_neutron-metadata-agent

	systemctl enable neutron-l3-agent
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_neutron-l3-agent

	if [ $1 = "allinone"  ];then
		systemctl enable nova-compute
        	aeron_service_enable_retval="$?"
        	aeron_cmd_stat $aeron_service_enable_retval $machine services_enable_fn_nova-compute
        fi
}

services_restart_fn () {
	systemctl restart chrony
	aeron_service_restart_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_chrony

	
	systemctl restart mariadb
	aeron_service_restart_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_mariadb

	systemctl restart memcached
        aeron_service_restart_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_memcached

	systemctl restart etcd
        aeron_service_restart_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_etcd

	systemctl restart apache2
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_apache2

	systemctl restart glance-api
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_glance-api

	systemctl restart nova-api
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_nova-api

	systemctl restart nova-scheduler
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_nova-scheduler

	systemctl restart nova-conductor
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_nova-conductor

	systemctl restart nova-novncproxy
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_nova-novncproxy

	systemctl restart neutron-server
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_neutron-server

	systemctl restart neutron-linuxbridge-agent
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_neutron-linuxbridge-agent

	systemctl restart neutron-dhcp-agent restart
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_neutron-dhcp-agent restart

	systemctl restart neutron-metadata-agent
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_neutron-metadata-agent

	systemctl restart neutron-l3-agent
        aeron_service_enable_retval="$?"
        aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_neutron-l3-agent

	if [ $1 = "allinone"  ];then
		systemctl restart nova-compute
        	aeron_service_enable_retval="$?"
        	aeron_cmd_stat $aeron_service_restart_retval $machine services_restart_fn_nova-compute
	fi
}

services_stop_fn () {
	echo "empty" 
}
main () {
	echo "service machine is $machine"
	echo "service arg is $1"
	if [ $1 = 'all'  ];then
		#echo "service machine is $machine"
		services_enable_fn $2
		aeron_service_retval="$?"
                aeron_cmd_stat $aeron_service_retval $machine services_main

		services_restart_fn $2
		aeron_service_retval="$?"
                aeron_cmd_stat $aeron_service_retval $machine services_main
	fi
	return 0
}

main $@
