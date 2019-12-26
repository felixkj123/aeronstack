#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)

machine=$(check_machine )

source $TOP_DIR/admin-openrc

start_init () {
	echo -e "\e[1;32mAeronstack_init started\e[0m"
	


	###Keystone
	openstack token issue; aeron_startinit_retval="$?";aeron_cmd_stat $aeron_startinit_retval $machine start_init

	openstack domain create --description "An Example Domain" example; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init

	openstack project create --domain default --description "Service Project" service; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init

	openstack project create --domain default --description "Demo Project" myproject; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init

	openstack user create --domain default --password $SERVICE_PASSWORD  myuser; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init

	openstack role create myrole; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init

	openstack role add --project myproject --user myuser myrole; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init


	###Glance

	openstack user create --domain default --password $SERVICE_PASSWORD glance; aeron_cmd_stat $aeron_startinit_retval $machine start_init

	openstack role add --project service --user glance admin; aeron_cmd_stat $aeron_startinit_retval $machine start_init

	openstack service create --name glance --description "OpenStack Image" image; aeron_cmd_stat $aeron_startinit_retval $machine start_init

	openstack endpoint create --region RegionOne image public http://controller:9292; aeron_cmd_stat $aeron_startinit_retval $machine start_init

	openstack endpoint create --region RegionOne image internal http://controller:9292; aeron_cmd_stat $aeron_startinit_retval $machine start_init

	openstack endpoint create --region RegionOne image admin http://controller:9292; aeron_cmd_stat $aeron_startinit_retval $machine start_init




	####initializing rabbitmq server
	#rabbitmqctl add_user openstack $RABBIT_PASSWORD
	#aeron_init_retval="$?"
        #aeron_cmd_stat $aeron_init_retval $machine arstack_init

	#
	#rabbitmqctl set_permissions openstack ".*" ".*" ".*"
	#aeron_init_retval="$?"
        #aeron_cmd_stat $aeron_init_retval $machine arstack_init


}

main () {
	
	start_init

}

main $@
