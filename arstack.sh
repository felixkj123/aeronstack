#!/bin/bash

. local.conf
. modules.sh

TOP_DIR=$(cd $(dirname "$0") && pwd)
BASH_DIR=$(which bash)

SUCCESS=0
ERROR=1

machine=$(check_machine )

checkrepo_fn () {
	
	#openstack train is taken by default for now
	add-apt-repository cloud-archive:train
	aeron_checkrepo_retval="$?"
        
	if [ $aeron_checkrepo_retval != $SUCCESS ]; then
		apt-get install -y software-properties-common ubuntu-cloud-keyring
		aeron_checkrepo_retval="$?"
		aeron_cmd_stat $aeron_checkrepo_retval $machine
		
		add-apt-repository cloud-archive:train
                aeron_checkrepo_retval="$?"
                aeron_cmd_stat $aeron_checkrepo_retval $machine
	fi
	
	apt update && apt dist-upgrade
	aeron_checkrepo_retval="$?"
        aeron_cmd_stat $aeron_checkrepo_retval $machine

	apt install python3-openstackclient
	aeron_checkrepo_retval="$?"
        aeron_cmd_stat $aeron_checkrepo_retval $machine
	
	return 1
}

main () {
	echo -e "\e[1;32mAeronstack Installation Started\e[0m"
	#machine=$(check_machine )
	if [ $1 = "all"  ];then
		
		checkrepo_fn
		aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine
		
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
