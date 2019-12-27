#!/bin/bash

. local.conf
. modules.sh
. arstackrc

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

		###keystone
		sed -i "/^#MDCDATABASECONNECTION/{n;d}" $ETC_ROOT_DIR/keystone/keystone.conf
                sed -i "/MDCDATABASECONNECTION/ a\connection = mysql+pymysql://keystone:$SERVICE_PASSWORD@controller/keystone" $ETC_ROOT_DIR/keystone/keystone.conf
		
		###glancce
		sed -i "/^#MDCDATABASECONNECTION/{n;d}" $ETC_ROOT_DIR/glance/glance-api.conf
		sed -i "/MDCDATABASECONNECTION/ a\connection = mysql+pymysql://glance:$SERVICE_PASSWORD@controller/glance" $ETC_ROOT_DIR/glance/glance-api.conf

		sed -i "/^#MDCGLANCEKESTONEAUTH/{n;d}" $ETC_ROOT_DIR/glance/glance-api.conf
                sed -i "/MDCGLANCEKESTONEAUTH/ a\password = $SERVICE_PASSWORD" $ETC_ROOT_DIR/glance/glance-api.conf

		sed -i "/^#MDCDATABASECONNECTION/{n;d}" $ETC_ROOT_DIR/glance/glance-registry.conf
                sed -i "/MDCDATABASECONNECTION/ a\connection = mysql+pymysql://glance:$SERVICE_PASSWORD@controller/glance" $ETC_ROOT_DIR/glance/glance-registry.conf

		sed -i "/^#MDCGLANCEKEYSTONEAUTH/{n;d}" $ETC_ROOT_DIR/glance/glance-registry.conf
                sed -i "/MDCGLANCEKEYSTONEAUTH/ a\password = $SERVICE_PASSWORD" $ETC_ROOT_DIR/glance/glance-registry.conf

		###placement
		sed -i "/^#MDCDATABASECONNECTION/{n;d}" $ETC_ROOT_DIR/placement/placement.conf
                sed -i "/MDCDATABASECONNECTION/ a\connection = mysql+pymysql://placement:$SERVICE_PASSWORD@controller/placement" $ETC_ROOT_DIR/placement/placement.conf

		sed -i "/^#MDCPLACEMENTKEYSTONEAUTH/{n;d}" $ETC_ROOT_DIR/placement/placement.conf
                sed -i "/MDCPLACEMENTKEYSTONEAUTH/ a\password = $SERVICE_PASSWORD" $ETC_ROOT_DIR/placement/placement.conf

		###nova
		sed -i "/^#MDCAPIDATABASE/{n;d}" $ETC_ROOT_DIR/nova/nova.conf
		sed -i "/MDCAPIDATABASE/ a\connection = mysql+pymysql://nova:$SERVICE_PASSWORD@controller/nova_api" $ETC_ROOT_DIR/nova/nova.conf

		sed -i "/^#MDCDATABASECONNECTION/{n;d}" $ETC_ROOT_DIR/nova/nova.conf
                sed -i "/MDCDATABASECONNECTION/ a\connection = mysql+pymysql://nova:$SERVICE_PASSWORD@controller/nova" $ETC_ROOT_DIR/nova/nova.conf

		sed -i "/^#MDCNOVATRANSPORT/{n;d}" $ETC_ROOT_DIR/nova/nova.conf
                sed -i "/MDCNOVATRANSPORT/ a\transport_url = rabbit://openstack:$SERVICE_PASSWORD@controller:5672/" $ETC_ROOT_DIR/nova/nova.conf

		sed -i "/^#MDCNOVAKEYSTONEAUTH/{n;d}" $ETC_ROOT_DIR/nova/nova.conf
                sed -i "/MDCNOVAKEYSTONEAUTH/ a\password = $SERVICE_PASSWORD" $ETC_ROOT_DIR/nova/nova.conf

		sed -i "/^#MDCMANAGEMENT_IP/{n;d}" $ETC_ROOT_DIR/nova/nova.conf
                sed -i "/MDCMANAGEMENT_IP/ a\my_ip = $MANAGEMENT_IP" $ETC_ROOT_DIR/nova/nova.conf

		sed -i "/^#MDCPLACEMENTAUTH/{n;d}" $ETC_ROOT_DIR/nova/nova.conf
                sed -i "/MDCPLACEMENTAUTH/ a\password = $SERVICE_PASSWORD" $ETC_ROOT_DIR/nova/nova.conf

		sed -i "/^#MDCNEUTRONAUTH/{n;d}" $ETC_ROOT_DIR/nova/nova.conf
                sed -i "/MDCNEUTRONAUTH/ a\password = $SERVICE_PASSWORD" $ETC_ROOT_DIR/nova/nova.conf

		sed -i "/^#MDCMETADATAPROXY/{n;d}" $ETC_ROOT_DIR/nova/nova.conf
                sed -i "/MDCMETADATAPROXY/ a\metadata_proxy_shared_secret = $SERVICE_PASSWORD" $ETC_ROOT_DIR/nova/nova.conf
		###neutron
		sed -i "/^#MDCDATABASECONNECTION/{n;d}" $ETC_ROOT_DIR/neutron/neutron.conf
                sed -i "/MDCDATABASECONNECTION/ a\connection = mysql+pymysql://neutron:$SERVICE_PASSWORD@controller/neutron" $ETC_ROOT_DIR/neutron/neutron.conf
		
		sed -i "/^#MDCNEUTRONTRANSPORT/{n;d}" $ETC_ROOT_DIR/neutron/neutron.conf
                sed -i "/MDCNEUTRONTRANSPORT/ a\transport_url = rabbit://openstack:$SERVICE_PASSWORD@controller" $ETC_ROOT_DIR/neutron/neutron.conf

		sed -i "/^#MDCNEUTRONKEYSTONEAUTH/{n;d}" $ETC_ROOT_DIR/neutron/neutron.conf
                sed -i "/MDCNEUTRONKEYSTONEAUTH/ a\password = $SERVICE_PASSWORD" $ETC_ROOT_DIR/neutron/neutron.conf
		
		sed -i "/^#MDCNOVAKEYSTONEAUTH/{n;d}" $ETC_ROOT_DIR/neutron/neutron.conf
                sed -i "/MDCNOVAKEYSTONEAUTH/ a\password = $SERVICE_PASSWORD" $ETC_ROOT_DIR/neutron/neutron.conf
		
		sed -i "/^#MDCPROVIDER_INTERFACE_NAME/{n;d}" $ETC_ROOT_DIR/neutron/plugins/ml2/linuxbridge_agent.ini
                sed -i "/MDCPROVIDER_INTERFACE_NAME/ a\physical_interface_mappings = provider:$PROVIDER_INTERFACE_NAME" $ETC_ROOT_DIR/neutron/plugins/ml2/linuxbridge_agent.ini
		
		sed -i "/^#MDCOVERLAY_INTERFACE_IP_ADDRESS/{n;d}" $ETC_ROOT_DIR/neutron/plugins/ml2/linuxbridge_agent.ini
                sed -i "/MDCOVERLAY_INTERFACE_IP_ADDRESS/ a\local_ip = $OVERLAY_INTERFACE_IP_ADDRESS" $ETC_ROOT_DIR/neutron/plugins/ml2/linuxbridge_agent.ini

		sed -i "/^#MDCMETADATAPROXYPASSWD/{n;d}" $ETC_ROOT_DIR/neutron/metadata_agent.ini
                sed -i "/MDCOVERLAY_INTERFACE_IP_ADDRESS/ a\metadata_proxy_shared_secret = $ADMIN_PASSWORD" $ETC_ROOT_DIR/neutron/metadata_agent.ini

		###novacompute
		if [ $1 = "allinone"  ]; then
			sed -i "/^#MDCNOVNCPROXYURL/{n;d}" $ETC_ROOT_DIR/nova/nova.conf
                	sed -i "/MDCNOVNCPROXYURL/ a\novncproxy_base_url = http://controller:6080/vnc_auto.html" $ETC_ROOT_DIR/nova/nova.conf
		fi

	elif [ $NODE = "compute" ]; then
		sed -i "/^#MDC_NTP_SERVERIP/{n;d}" $ETC_ROOT_DIR/chrony/chrony.conf
                sed -i "/MDC_NTP_SERVERIP/ a\server $SERVICE_HOST iburst" $ETC_ROOT_DIR/chrony/chrony.conf
                sed -i "/^#MDC_SUBNET_MASK/{n;d}" $ETC_ROOT_DIR/chrony/chrony.conf
                sed -i "/MDC_SUBNET_MASK/ a\allow $HOST_SUBNET_MASK/$HOST_SUBNET_BITS" $ETC_ROOT_DIR/chrony/chrony.conf

	fi
}

main () {
	replace_fn $2
	aeron_replace_retval="$?"
        aeron_cmd_stat $aeron_replace_retval $machine replacefiles.sh

	return 0
}

main $@
