#!/bin/bash

. local.conf
. modules.sh

TOP_DIR=$(cd $(dirname "$0") && pwd)

ETC_DIR="$TOP_DIR/etc"
ETC_ROOT_DIR="/etc/"

machine=$(check_machine )

copy_fn () {

	sudo cp $ETC_DIR/chrony.conf $ETC_ROOT_DIR/chrony/
	aeron_copy_retval="$?"
        aeron_cmd_stat $aeron_copy_retval $machine
	
}

main() {
	copy_fn
	return 0
}

main $@
