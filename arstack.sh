#!/bin/bash

. local.conf
. modules.sh

TOP_DIR=$(cd $(dirname "$0") && pwd)
BASH_DIR=$(which bash)

main () {
	echo -e "\e[1;32mAeronstack Installation Started\e[0m"
	machine=$(check_machine )
	if [ $1 = "all"  ];then
		$BASH_DIR $TOP_DIR/install.sh
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine
		
		$BASH_DIR $TOP_DIR/movfiles.sh
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine	

		$BASH_DIR $TOP_DIR/replacefiles.sh
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine

		$BASH_DIR $TOP_DIR/services.sh start_all
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine
	fi
}
main $@
