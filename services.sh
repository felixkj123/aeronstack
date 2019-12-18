#!/bin/bash

. local.conf
. modules.sh

TOP_DIR=$(cd $(dirname "$0") && pwd)


machine=$(check_machine )

services_enable_fn() {
	systemctl enable chrony
}

services_restart_fn () {
	systemctl restart chrony
}

services_stop_fn () {
	echo "empty" 
}
main () {
	echo "service machine is $machine"
	echo "service arg is $1"
	if [ $1 = 'start_all'  ];then
		#echo "service machine is $machine"
		services_enable_fn
		aeron_service_retval="$?"
                aeron_cmd_stat $aeron_service_retval $machine

		services_restart_fn
		aeron_service_retval="$?"
                aeron_cmd_stat $aeron_service_retval $machine
	fi
	return 0
}

main $@
