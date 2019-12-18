#!/bin/bash

. local.conf
. modules.sh

TOP_DIR=$(cd $(dirname "$0") && pwd)


main () {
	echo -e "\e[1;32mAeronstack Installation Started\e[0m"
	machine=$(check_machine )
	if [ $1 = "all"  ];then
		.$TOP_DIR/install.sh
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine
		
		.$TOP_DIR/movfiles.sh
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine	

		.$TOP_DIR/services.sh
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine

		.$TOP_DIR/services
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine
	fi
}
main $@
