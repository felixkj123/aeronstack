#!/bin/bash

SUCCESS=0
ERROR=1
ERROR_CMD="error"
SUCCESS_CMD="success"

check_machine() {

	retval=""
        machine=$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed "s/\"//g")
        echo "$machine"
}

aeron_cmd_stat () {

        echo -e "\e[1;32maeron_cmd_stat\e[0m"
        if [ $2 = 'Ubuntu'  ]; then
                if [ $1 != $SUCCESS  ]; then
                        echo -e "\e[1;32mcmd failure...\e[0m"
                        exit 1
                else
                        echo "Done\n"
                fi
        fi
}


check_args_auth_fn () {
	
	f_flag=$ERROR
	shift
	for j in $@
	do
        	for i in $CONT_DEFAULT_SERVICES
        	do
        	        if [ $j = $i  ];then
        	        	f_flag=$SUCCESS
        			break
			fi
        	done
	done
	if [ $f_flag != $SUCCESS ]; then
                echo "$ERROR_CMD"
        
        else
                echo "$j"
        fi
}

check_command_auth_fn (){
	
        f_flag=$ERROR
	for i in $AVAILABLE_COMMANDS
        do
                if [ $1 = $i  ]; then
			f_flag=$SUCCESS
			break
		fi

        done
	if [ $f_flag != $SUCCESS ]; then
        	echo "$ERROR_CMD"
	
	else
		echo "$1"
	fi
}


script_usage () {

	case $1 in
		default)
			printf '%-4s\n' "=================================Usage==================================="
			printf '%-4s\n' "./arstack.sh <command> <arg1...arg2....argn>"
			printf '%-4s\n' "command		: all/clean"
			printf '%-4s\n' "arg    		: all/<service name>"
			printf '%-4s\n' "service name	: name of service"
			printf '%-4s\n' "(note:view the aronstackrc file to view the list of supported services,"
	        	printf '%-4s\n' "currently written only for cleaning purposes only...script early version)"
			printf '%-4s\n' "=================================Usage==================================="
			;;
		      *)
			echo "script usage not written"
		esac
}

check_args_fn(){

	#echo "entered command is $1, check_args_fn"
	aeron_checkcommand_retval=$(check_command_auth_fn $@ )
	#echo "the command retval is $aeron_checkcommand_retval"
	case $aeron_checkcommand_retval in
		ERROR)
				echo -e "\e[1;31mEnter the correct command\e[0m"
				script_usage default
			;;

		all)
				#echo "the command retval is $aeron_checkcommand_retval"
				return $SUCCESS
			;;
		*)
				if [ $# -eq 1  ];then
                        		echo -e "\e[1;31mArgument count not met\e[0m"
                        		script_usage default
					
					return $ERROR
                		else
                        		aeron_checkcommand_retval=$(check_args_auth_fn $@)
					case $aeron_checkcommand_retval in
						ERROR)
								echo -e "\e[1;31mArgument not correct\e[0m"
		        	                        	script_usage default
							;;
						all)
								return $SUCCESS
							;;

						*)
							echo -e "\e[1;31mEnter the correct argument\e[0m"
                                                        script_usage default
							return $SUCCESS

					esac	

                		fi
			
	esac

}

