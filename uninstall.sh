#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)
machine=$(check_machine )


uninstall_fn () {
	echo "inside uninstall function"
	apt-get purge mariadb-server chrony etcd rabbitmq-server memcached -y
	return 0

}

main () {
	
	if [ $2 = "all"  ]; then
		uninstall_fn
		aeron_uninstall_retval="$?"
        	aeron_cmd_stat $aeron_uninstall_retval $machine
	fi
}

main $@
