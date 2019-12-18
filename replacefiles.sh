#!/bin/bash

. local.conf
. modules.sh

TOP_DIR=$(cd $(dirname "$0") && pwd)
ETC_ROOT_DIR="/etc"

machine=$(check_machine )

replace_fn () {
	##edit chrony.conf
	sed -i '/MDC_NTP_SERVERIP/ c\server $HOST_IP iburst  #MDC_NTP_SERVERIP' $ETC_ROOT_DIR/chrony/chrony.conf
	sed -i '/MDC_SUBNET_MASK/ c\allow $HOST_SUBNET_MASK/$HOST_SUBNET_BITS     #MDC_SUBNET_MASK' $ETC_ROOT_DIR/chrony/chrony.conf

}

main () {
	replace_fn
	aeron_replace_retval="$?"
        aeron_cmd_stat $aeron_replace_retval $machine

	return 0
}

main $@
