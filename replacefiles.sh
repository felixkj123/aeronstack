#!/bin/bash

. local.conf
. modules.sh

TOP_DIR=$(cd $(dirname "$0") && pwd)
ETC_ROOT_DIR="/etc"

machine=$(check_machine )

replace_fn () {
	##edit chrony.conf
	if [ $NODE = "controller" ]; then
		###chrony config files
		sed -i "/^#MDC_NTP_SERVERIP/{n;d}" $ETC_ROOT_DIR/chrony/chrony.conf
		sed -i "/MDC_NTP_SERVERIP/ a\server $HOST_IP iburst" $ETC_ROOT_DIR/chrony/chrony.conf
		sed -i "/^#MDC_SUBNET_MASK/{n;d}" $ETC_ROOT_DIR/chrony/chrony.conf
		sed -i "/MDC_SUBNET_MASK/ a\allow $HOST_SUBNET_MASK/$HOST_SUBNET_BITS" $ETC_ROOT_DIR/chrony/chrony.conf

		###mariadb database config files
		#bind ip set by Default from $TOP_DIR/etc/99-openstack.cnf

		###rabbitmq

		###memcached

		###etcd
		sed -i "/ETCD_INITIAL_CLUSTER/ c\ETCD_INITIAL_CLUSTER="controller=http://$HOST_IP:2380"" $ETC_ROOT_DIR/default/etcd
		sed -i "/ETCD_INITIAL_ADVERTISE_PEER_URLS/ c\ETCD_INITIAL_ADVERTISE_PEER_URLS="http://$HOST_IP:2380"" $ETC_ROOT_DIR/default/etcd
		sed -i "/ETCD_ADVERTISE_CLIENT_URLS/ c\ETCD_ADVERTISE_CLIENT_URLS="http://$HOST_IP:2379"" $ETC_ROOT_DIR/default/etcd
		sed -i "/ETCD_LISTEN_CLIENT_URLS/ c\ETCD_LISTEN_CLIENT_URLS="http://$HOST_IP:2379"" $ETC_ROOT_DIR/default/etcd

	elif [ $NODE = "compute" ]; then
		sed -i "/^#MDC_NTP_SERVERIP/{n;d}" $ETC_ROOT_DIR/chrony/chrony.conf
                sed -i "/MDC_NTP_SERVERIP/ a\server $SERVICE_HOST iburst" $ETC_ROOT_DIR/chrony/chrony.conf
                sed -i "/^#MDC_SUBNET_MASK/{n;d}" $ETC_ROOT_DIR/chrony/chrony.conf
                sed -i "/MDC_SUBNET_MASK/ a\allow $HOST_SUBNET_MASK/$HOST_SUBNET_BITS" $ETC_ROOT_DIR/chrony/chrony.conf

	fi
}

main () {
	replace_fn
	aeron_replace_retval="$?"
        aeron_cmd_stat $aeron_replace_retval $machine

	return 0
}

main $@
