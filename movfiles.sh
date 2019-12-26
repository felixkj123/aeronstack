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
        aeron_cmd_stat $aeron_copy_retval $machine copy_fn

	sudo cp $ETC_DIR/99-openstack.cnf $ETC_ROOT_DIR/mysql/mariadb.conf.d
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_fn
	
	sudo cp $ETC_DIR/memcached.conf $ETC_ROOT_DIR/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_fn

	sudo cp $ETC_DIR/etcd $ETC_ROOT_DIR/default/etcd
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_fn
	
	sudo cp $ETC_DIR/keystone.conf $ETC_ROOT_DIR/keystone/
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_fn

	sudo cp $ETC_DIR/apache2.conf $ETC_ROOT_DIR/apache2/apache2.conf
        aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_fn

	sudo cp $ETC_DIR/admin-openrc $TOP_DIR
	aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine copy_fn



}

main() {
	copy_fn
	return 0
}

main $@
