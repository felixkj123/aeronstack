#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)

machine=$(check_machine )

db_populate_fn () {
	case $NODE in
		controller)
				###KEYSTONE
				#populating the database
				su -s /bin/sh -c "keystone-manage db_sync" keystone
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
