#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)

machine=$(check_machine )

db_create_fn () {

	echo "inside db_create_fn1"
	mysql -u root -p$ADMIN_PASSWORD -e "CREATE DATABASE $1;"
	aeron_dbcreate_retval="$?"
        aeron_cmd_stat $aeron_dbcreate_retval $machine dbinit_create_fn

	mysql -u root -p$ADMIN_PASSWORD -e "GRANT ALL PRIVILEGES ON $1.* TO '$2'@'localhost' IDENTIFIED BY '$SERVICE_PASSWORD';"
	aeron_dbcreate_retval="$?"
        aeron_cmd_stat $aeron_dbcreate_retval $machine dbinit_create_fn

	mysql -u root -p$ADMIN_PASSWORD -e "GRANT ALL PRIVILEGES ON $1.* TO '$2'@'%' IDENTIFIED BY '$SERVICE_PASSWORD';"
	aeron_dbcreate_retval="$?"
        aeron_cmd_stat $aeron_dbcreate_retval $machine dbinit_create_fn
	echo "inside db_create_fn2"
}

dbinit_fn() {

	db_create_fn keystone keystone
	aeron_dbinit_retval="$?"
        aeron_cmd_stat $aeron_dbinit_retval $machine dbinit_fn_keystone

	db_create_fn glance glance
        aeron_dbinit_retval="$?"
        aeron_cmd_stat $aeron_dbinit_retval $machine dbinit_fn_glance

	db_create_fn placement placement
        aeron_dbinit_retval="$?"
        aeron_cmd_stat $aeron_dbinit_retval $machine dbinit_fn_placement

	db_create_fn nova_api nova
        aeron_dbinit_retval="$?"
        aeron_cmd_stat $aeron_dbinit_retval $machine dbinit_fn_nova_api
 
	db_create_fn nova nova
        aeron_dbinit_retval="$?"
        aeron_cmd_stat $aeron_dbinit_retval $machine dbinit_fn_nova

	db_create_fn nova_cell0 nova
        aeron_dbinit_retval="$?"
        aeron_cmd_stat $aeron_dbinit_retval $machine dbinit_fn_nova_cell0

	db_create_fn neutron neutron
        aeron_dbinit_retval="$?"
        aeron_cmd_stat $aeron_dbinit_retval $machine dbinit_fn_nova_cell0

}

main () {
	
	dbinit_fn 
	aeron_dbinit_retval="$?"
        aeron_cmd_stat $aeron_dbinit_retval $machine dbinit_main

}

main $@
