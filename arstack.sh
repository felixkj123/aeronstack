#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)
BASH_DIR=$(which bash)

SUCCESS=0
ERROR=1

machine=$(check_machine )

#check_service_auth_fn () {
#
#	for i in $CONT_DEFAULT_SERVICES
#	do
#		if [ $1 != !i  ];then
#			aeron_checkservice_retval=$ERROR
#                        aeron_cmd_stat $aeron_checkservice_retval $machine
#		fi
#	done
#}
#
#check_command_auth_fn (){
#
#	for i in $AVAILABLE_COMMANDS
#	do
#		if [ $1 != $i  ]; then			
#			aeron_checkcommand_retval=$ERROR
#	                aeron_cmd_stat $aeron_checkcommand_retval $machine
#		fi
#	done	
#	return $SUCCESS
#}

checkrepo_fn () {
	
	#openstack train is taken by default for now
	add-apt-repository cloud-archive:train -y
	aeron_checkrepo_retval="$?"
        
	if [ $aeron_checkrepo_retval != $SUCCESS ]; then
		apt-get install -y software-properties-common ubuntu-cloud-keyring
		aeron_checkrepo_retval="$?"
		aeron_cmd_stat $aeron_checkrepo_retval $machine arstack_checkrepo
		
		add-apt-repository cloud-archive:train -y
                aeron_checkrepo_retval="$?"
                aeron_cmd_stat $aeron_checkrepo_retval $machine arstack_checkrepo
	fi
	
	apt update && apt dist-upgrade
	aeron_checkrepo_retval="$?"
        aeron_cmd_stat $aeron_checkrepo_retval $machine arstack_checkrepo

	apt install python3-openstackclient -y
	aeron_checkrepo_retval="$?"
        aeron_cmd_stat $aeron_checkrepo_retval $machine arstack_checkrepo
	
	return 0
}

main () {
	echo -e "\e[1;32mAeronstack Installation Started\e[0m"
	echo -e "\e[1;32mBefore check_args_fn\e[0m"
	check_args_fn $@
	aeron_install_retval="$?"
        aeron_cmd_stat $aeron_install_retval $machine
	echo -e "\e[1;32mAfter check_args_fn\e[0m"

	if [ $1 = "all"  ];then
		
		checkrepo_fn
		aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine arstack_main_checkrepo
		
		$BASH_DIR $TOP_DIR/install.sh $@
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine arstack_main_install
		
		$BASH_DIR $TOP_DIR/movfiles.sh
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine arstack_main_movfiles

		$BASH_DIR $TOP_DIR/replacefiles.sh
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine arstack_main_replace


		$BASH_DIR $TOP_DIR/dbinit.sh
		aeron_install_retval="$?"
		aeron_cmd_stat $aeron_install_retval $machine arstack_main_dbinit

		
		###have to create a openstackinit.sh script
		
		
		$BASH_DIR $TOP_DIR/dbpopulate.sh
                aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine arstack_main_dbpopulate
		
		$BASH_DIR $TOP_DIR/services.sh start_all
		aeron_install_retval="$?"
        	aeron_cmd_stat $aeron_install_retval $machine arstack_main_services

		$BASH_DIR $TOP_DIR/arstack_init.sh
		aeron_install_retval="$?"
                aeron_cmd_stat $aeron_install_retval $machine arstack_main_arstack_init


	elif [ $1 = "clean"  ]; then
		$BASH_DIR $TOP_DIR/uninstall.sh $@
	fi

	echo -e "\e[1;32mAeronstack Installation Finished\e[0m"
}
main $@
