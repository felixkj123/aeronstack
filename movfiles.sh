#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)

ETC_DIR="$TOP_DIR/etc"
ETC_ROOT_DIR="/etc/"

machine=$(check_machine )

copy_fn () {

	sudo cp $ETC_DIR/chrony.conf $ETC_ROOT_DIR/chrony/
	aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_chrony

	sudo cp $ETC_DIR/99-openstack.cnf $ETC_ROOT_DIR/mysql/mariadb.conf.d
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_mariadb
	
	sudo cp $ETC_DIR/memcached.conf $ETC_ROOT_DIR/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_memcached

	sudo cp $ETC_DIR/etcd $ETC_ROOT_DIR/default/etcd
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_etcd
	
	sudo cp $ETC_DIR/keystone.conf $ETC_ROOT_DIR/keystone/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_keystone

	sudo cp $ETC_DIR/apache2.conf $ETC_ROOT_DIR/apache2/apache2.conf
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_apache2

	sudo cp $ETC_DIR/admin-openrc $TOP_DIR
	aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_adminopenrc

	sudo cp $ETC_DIR/glance-api.conf $ETC_ROOT_DIR/glance
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_glance-api

	sudo cp $ETC_DIR/glance-registry.conf $ETC_ROOT_DIR/glance
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_glance-registry

}

main() {
	copy_fn
	return 0
}

main $@
