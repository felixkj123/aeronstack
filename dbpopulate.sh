#!/bin/bash

. local.conf
. modules.sh
. arstackrc

TOP_DIR=$(cd $(dirname "$0") && pwd)

machine=$(check_machine )


img_service_db_populate_fn () {

	#populating the database
        su -s /bin/sh -c "$1-manage $2" $1
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
				img_service_db_populate_fn keystone "db_sync"
				aeron_dbpopulate_retval="$?"
		                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn_keystone
				
				#fernet key initializing
				keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
				aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn_keystone_fernet_setup
				keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
				aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn_keystone_credential_setup

				#bootstraping
				keystone-manage bootstrap --bootstrap-password $ADMIN_PASSWORD \
				  --bootstrap-admin-url http://controller:5000/v3/ \
				  --bootstrap-internal-url http://controller:5000/v3/ \
				  --bootstrap-public-url http://controller:5000/v3/ \
				  --bootstrap-region-id RegionOne
				aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn_bootstraping

				###glance
				img_service_db_populate_fn glance "db_sync"
                                aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn_glance
				
				###placement
				img_service_db_populate_fn placement "db sync"
                                aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn_placement

				###nova
                                img_service_db_populate_fn nova "api_db sync"
                                aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn_nova_api_db_sync

                                img_service_db_populate_fn nova "cell_v2 map_cell0"
                                aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn_nova_map_cell0

                                img_service_db_populate_fn nova "cell_v2 create_cell --name=cell1 --verbose"
                                aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn_nova_create_cell1

                                img_service_db_populate_fn nova "db sync"
                                aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn_nova_db_sync

                                img_service_db_populate_fn nova "cell_v2 list_cells"
                                aeron_dbpopulate_retval="$?"
                                aeron_cmd_stat $aeron_dbpopulate_retval $machine dbpopulate_fn_nova_list_cells


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
