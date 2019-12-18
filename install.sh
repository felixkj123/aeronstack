#!/bin/bash

. local.conf
. modules.sh

TOP_DIR=$(cd $(dirname "$0") && pwd)

PKG_TOOL=""

SUCCESS=0
ERROR=1

machine=$(check_machine )

echo "the machine is <<$machine>>"

find_package_fn () {
	case $machine in
		"Ubuntu")
			PKG_TOOL="apt"
			;;
		"CentOS Linux")
			PKG_TOOL="yum"
			;;
		*)
			PKG_TOOL="error"
	esac
}

install_fn () {
	if [ $NODE = 'controller'  ]; then
		#echo $PKG_TOOL
		#$PKG_TOOL update
		#aeron_install_retval="$?"
		#aeron_cmd_stat $aeron_install_retval $machine
	
		$PKG_TOOL install chrony -y
	        aeron_install_retval="$?"
	        aeron_cmd_stat $aeron_install_retval $machine
	
	
	fi
}


main () {
	find_package_fn
	install_fn
	return 0	
}
main $@
