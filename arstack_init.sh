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
	openstack token issue; aeron_startinit_retval="$?";aeron_cmd_stat $aeron_startinit_retval $machine start_init_keystone

	openstack domain create --description "An Example Domain" example; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init_keystone

	openstack project create --domain default --description "Service Project" service; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init_keystone

	openstack project create --domain default --description "Demo Project" myproject; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init_keystone

	openstack user create --domain default --password $SERVICE_PASSWORD  myuser; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init_keystone

	openstack role create myrole; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init_keystone

	openstack role add --project myproject --user myuser myrole; aeron_startinit_retval="$?" ; aeron_cmd_stat $aeron_startinit_retval $machine start_init_keystone


	###Glance

	openstack user create --domain default --password $SERVICE_PASSWORD glance; aeron_cmd_stat $aeron_startinit_retval $machine start_init_glance

	openstack role add --project service --user glance admin; aeron_cmd_stat $aeron_startinit_retval $machine start_init_glance

	openstack service create --name glance --description "OpenStack Image" image; aeron_cmd_stat $aeron_startinit_retval $machine start_init_glance

	openstack endpoint create --region RegionOne image public http://controller:9292; aeron_cmd_stat $aeron_startinit_retval $machine start_init_glance

	openstack endpoint create --region RegionOne image internal http://controller:9292; aeron_cmd_stat $aeron_startinit_retval $machine start_init_glance

	openstack endpoint create --region RegionOne image admin http://controller:9292; aeron_cmd_stat $aeron_startinit_retval $machine start_init_glance




	####initializing rabbitmq server
	#rabbitmqctl add_user openstack $RABBIT_PASSWORD
	#aeron_init_retval="$?"
        #aeron_cmd_stat $aeron_init_retval $machine arstack_init

	#
	#rabbitmqctl set_permissions openstack ".*" ".*" ".*"
	#aeron_init_retval="$?"
        #aeron_cmd_stat $aeron_init_retval $machine arstack_init

	###placement
	openstack user create --domain default --password $SERVICE_PASSWORD placement; aeron_cmd_stat $aeron_startinit_retval $machine start_init_placement

	openstack role add --project service --user placement admin; aeron_cmd_stat $aeron_startinit_retval $machine start_init_placement

	openstack service create --name placement --description "Placement API" placement; aeron_cmd_stat $aeron_startinit_retval $machine start_init_placement

	openstack endpoint create --region RegionOne placement public http://controller:8778; aeron_cmd_stat $aeron_startinit_retval $machine start_init_placement

	openstack endpoint create --region RegionOne placement internal http://controller:8778; aeron_cmd_stat $aeron_startinit_retval $machine start_init_placement

	openstack endpoint create --region RegionOne placement admin http://controller:8778; aeron_cmd_stat $aeron_startinit_retval $machine start_init_placement


	###nova
	openstack user create --domain default --password $SERVICE_PASSWORD nova; aeron_cmd_stat $aeron_startinit_retval $machine start_init_nova

	openstack role add --project service --user nova admin; aeron_cmd_stat $aeron_startinit_retval $machine start_init_nova

	openstack service create --name nova --description "OpenStack Compute" compute; aeron_cmd_stat $aeron_startinit_retval $machine start_init_nova

	openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1; aeron_cmd_stat $aeron_startinit_retval $machine start_init_nova

	openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1; aeron_cmd_stat $aeron_startinit_retval $machine start_init_nova

	openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1; aeron_cmd_stat $aeron_startinit_retval $machine start_init_nova

	###neutron
	openstack user create --domain default --password $SERVICE_PASSWORD neutron; aeron_cmd_stat $aeron_startinit_retval $machine start_init_neutron

	openstack role add --project service --user neutron admin; aeron_cmd_stat $aeron_startinit_retval $machine start_init_neutron

	openstack service create --name neutron --description "OpenStack Networking" network; aeron_cmd_stat $aeron_startinit_retval $machine start_init_neutron

	openstack endpoint create --region RegionOne network public http://controller:9696; aeron_cmd_stat $aeron_startinit_retval $machine start_init_neutron

	openstack endpoint create --region RegionOne network internal http://controller:9696; aeron_cmd_stat $aeron_startinit_retval $machine start_init_neutron

	openstack endpoint create --region RegionOne network admin http://controller:9696; aeron_cmd_stat $aeron_startinit_retval $machine start_init_neutron

}



main () {
	
	start_init

}

main $@
