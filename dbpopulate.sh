#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)

machine=$(check_machine )


img_service_db_populate_fn () {

	#populating the database
        su -s /bin/sh -c "$1-manage db_sync" $1
	aeron_imgservicedbpopulate_retval="$?"
        aeron_cmd_stat $aeron_imgservicedbpopulate_retval $machine img_service_db_populate_fn
	return $SUCCESS
}

db_populate_fn () {
	case $NODE in
		controller)
				###KEYSTONE
				#populating the database
				#su -s /bin/sh -c "keystone-manage db_sync" keystone
				img_service_db_populate_fn keystone
				aeron_dbpopulate_retval="$?"
		                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn
				
				#fernet key initializing
				keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
				aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn
				keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
				aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn

				#bootstraping
				keystone-manage bootstrap --bootstrap-password $ADMIN_PASSWORD \
				  --bootstrap-admin-url http://controller:5000/v3/ \
				  --bootstrap-internal-url http://controller:5000/v3/ \
				  --bootstrap-public-url http://controller:5000/v3/ \
				  --bootstrap-region-id RegionOne
				aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn

				img_service_db_populate_fn glance
                                aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn


				return $SUCCESS	
				;;
		compute)	
				echo "nothing to do in dbpopulate.sh"
				;;
		*)		
				echo "Enter the correct node name"
				exit 1
	

	esac

}

main () {
	db_populate_fn
	aeron_dbpopulate_retval="$?"
        aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_main

}

main $@
