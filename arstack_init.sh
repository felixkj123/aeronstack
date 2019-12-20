#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)


start_init () {
	echo -e "\e[1;32mAeronstack_init started\e[0m"
	
	###initializing rabbitmq server
	rabbitmqctl add_user openstack $RABBIT_PASSWORD
	aeron_init_retval="$?"
        aeron_cmd_stat $aeron_init_retval $machine

	
	rabbitmqctl set_permissions openstack ".*" ".*" ".*"
	aeron_init_retval="$?"
        aeron_cmd_stat $aeron_init_retval $machine

}

main () {
	start_init

}

main $@
