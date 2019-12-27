#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)

ETC_DIR="$TOP_DIR/etc"
ETC_ROOT_DIR="/etc/"

machine=$(check_machine )

copy_fn () {

	###chrony
	sudo cp $ETC_DIR/chrony.conf $ETC_ROOT_DIR/chrony/
	aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_chrony

	###database
	sudo cp $ETC_DIR/99-openstack.cnf $ETC_ROOT_DIR/mysql/mariadb.conf.d
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_mariadb
	
	###memcached
	sudo cp $ETC_DIR/memcached.conf $ETC_ROOT_DIR/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_memcached

	###etcd
	sudo cp $ETC_DIR/etcd $ETC_ROOT_DIR/default/etcd
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_etcd
	
	###keystone
	sudo cp $ETC_DIR/keystone.conf $ETC_ROOT_DIR/keystone/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_keystone

	sudo cp $ETC_DIR/apache2.conf $ETC_ROOT_DIR/apache2/apache2.conf
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_apache2

	sudo cp $ETC_DIR/admin-openrc $TOP_DIR
	aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_adminopenrc

	###glance
	sudo cp $ETC_DIR/glance-api.conf $ETC_ROOT_DIR/glance
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_glance-api

	sudo cp $ETC_DIR/glance-registry.conf $ETC_ROOT_DIR/glance
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_glance-registry

	###placement	
	sudo cp $ETC_DIR/placement.conf $ETC_ROOT_DIR/placement/placement.conf
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_glance-registry

	###nova
	sudo cp $ETC_DIR/nova.conf $ETC_ROOT_DIR/nova/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_glance-registry

	###neutron
	sudo cp $ETC_DIR/neutron.conf $ETC_ROOT_DIR/neutron/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_neutron_conf

	sudo cp $ETC_DIR/ml2_conf.ini $ETC_ROOT_DIR/neutron/plugins/ml2/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_glance-registry

	sudo cp $ETC_DIR/linuxbridge_agent.ini $ETC_ROOT_DIR/neutron/plugins/ml2/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_glance-registry

	sudo cp $ETC_DIR/l3_agent.ini $ETC_ROOT_DIR/neutron/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_glance-registry

	sudo cp $ETC_DIR/dhcp_agent.ini $ETC_ROOT_DIR/neutron/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_glance-registry

	sudo cp $ETC_DIR/local_settings.py $ETC_ROOT_DIR/openstack-dashboard/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_openstack-dashboard_localsettings

	sudo cp $ETC_DIR/openstack-dashboard.conf $ETC_ROOT_DIR/apache2/conf-available/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_openstack-dashboardconf
	
}

main() {
	copy_fn
	return 0
}

main $@
