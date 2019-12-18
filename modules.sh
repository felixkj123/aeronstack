#!/bin/bash

SUCCESS=0
ERROR=1

check_machine() {
        retval=""
        machine=$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed "s/\"//g")
        echo "$machine"
}

aeron_cmd_stat () {
        echo -e "\e[1;32maeron_cmd_stat\e[0m"

        #echo "aeron_cmd_stat is $1"
        if [ $2 = 'Ubuntu'  ]; then
                if [ $1 != $SUCCESS  ]; then
                        echo -e "\e[1;32mcmd failure...\e[0m"
                        exit 1
                else
                        echo "Done\n"

                fi
        fi
}
