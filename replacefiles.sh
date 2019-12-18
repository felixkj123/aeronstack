#!/bin/bash

. local.conf
. modules.sh

TOP_DIR=$(cd $(dirname "$0") && pwd)
ETC_ROOT_DIR="/etc"

machine=$(check_machine )

replace_fn () {
	##edit chrony.conf
	sed -i "/^#MDC_NTP_SERVERIP/{n;d}" $ETC_ROOT_DIR/chrony/chrony.conf
	sed -i "/MDC_NTP_SERVERIP/ a\server $HOST_IP iburst" $ETC_ROOT_DIR/chrony/chrony.conf
	sed -i "/^#MDC_SUBNET_MASK/{n;d}" $ETC_ROOT_DIR/chrony/chrony.conf
	sed -i "/MDC_SUBNET_MASK/ a\allow $HOST_SUBNET_MASK/$HOST_SUBNET_BITS" $ETC_ROOT_DIR/chrony/chrony.conf

}

main () {
	replace_fn
	aeron_replace_retval="$?"
        aeron_cmd_stat $aeron_replace_retval $machine

	return 0
}

main $@
