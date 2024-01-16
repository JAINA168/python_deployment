#!/bin/bash

failedFiles=() # Array to store failed JIL files
successfulFiles=() # Array to store successful JIL files

USERNAME="${USERNAME}"
PASSWORD="${PASSWORD}"

target_branch=${GIT_BRANCH}
echo "Target branch is: ${target_branch}"
echo "Dry run is: ${dry_run}"
if [ "${dry_run}" = "Yes" ]; then
    echo "Dry run is enabled. Below are the changesets for Autosys deployment:"
    
    # List files in the Autosys folder
    files_in_autosys_folder=$(find "${jilDirectory}" -name '*.jil')
    for file in ${files_in_autosys_folder}; do
        echo "${file}"
    done
    
    # Exit with a successful status
    exit 0
fi

# Get a list of JIL files in the directory
jilFiles=$(find "${jilDirectory}" -name '*.jil')


# Iterate over the JIL files and make POST requests
for jilFile in ${jilFiles}; do
    echo "Processing file: ${jilFile}"
    if [ "${target_branch}" = "test" ]; then
		# Replace string in the JIL file for the "test" branch
		sed -i 's/d2compaemea/t2compaemea/g' "${jilFile}"
		sed -i 's/D2COMPAEMEA/T2COMPAEMEA/g' "${jilFile}"
		sed -i "s/$autosys_dev_server/$autosys_test_server/g" "${jilFile}"
		# sed -i 's/pa_matillion_master\.ksh PALIGN EMEA_DEV \(.*\) PFZALGN_DEV PFZALGN_DEV/pa_matillion_master.ksh PALIGN TEST \1 PFZALGN_TEST PFZALGN_TEST/g' "${jilFile}"
		sed -i 's/pa_postgresql_master.ksh PALIGN EMEA_DEV/pa_postgresql_master.ksh PALIGN EMEA_TEST/g' "${jilFile}"
		# sed -i 's/pa_postgresql_master.ksh PALIGN DEV_IDL/pa_postgresql_master.ksh PALIGN TEST_IDL/g' "${jilFile}"
		# sed -i 's/pa_snowflake_master.ksh cometl_pa_ods_dev/pa_snowflake_master.ksh cometl_pa_ods_test/g' "${jilFile}"
		# sed -i 's/pa_sf_ae_load_status_check.ksh cometl_pa_ods_dev/pa_sf_ae_load_status_check.ksh cometl_pa_ods_test/g' "${jilFile}"
		#sed -i 's/master_batch_upload.ksh DEV/master_batch_upload.ksh TEST/g' "${jilFile}"
		# sed -i 's/master_cascade_notification.ksh DEV/master_cascade_notification.ksh TEST/g' "${jilFile}"
		sed -i 's/master_dataloader.ksh ORACLE_EU PROD EMEA_DEV/master_dataloader.ksh ORACLE_EU PROD EMEA_TEST/g' "${jilFile}"
		# sed -i 's/pa_file_transfer.ksh PALIGN DEV/pa_file_transfer.ksh PALIGN TEST/g' "${jilFile}"
		# sed -i 's/pa_file_purge.ksh PALIGN DEV/pa_file_purge.ksh PALIGN TEST/g' "${jilFile}"
		# sed -i 's/pa_snowflake_prevalidn_master.ksh cometl_pa_ods_dev/pa_snowflake_prevalidn_master.ksh cometl_pa_ods_test/g' "${jilFile}"
  		# sed -i 's/pa_sf_pub_prev_job_status_chk.ksh cometl_pa_ods_dev/pa_sf_pub_prev_job_status_chk.ksh cometl_pa_ods_test/g' "${jilFile}"
  		# sed -i 's/pa_autosys_job_dtls.ksh PALIGN DEV/pa_autosys_job_dtls.ksh PALIGN TEST/g' "${jilFile}"
		sed -i 's/machine: emeavopsfa00001/machine: emaaelp00010092/g' "${jilFile}"
		sed -i 's/owner: SRVAMR-PALIGN/owner: SRVAMR-PALIGNEM/g' "${jilFile}"
		sed -i 's/master_xref_refresh.ksh EMEA_DEV/master_xref_refresh.ksh EMEA_TEST/g' "${jilFile}"
		sed -i 's/pa_matillion_master.ksh PALIGN EMEA_DEV EMEA_AE_FULL PFZALGN_EX_US_DEV PFZALGN_DEV_EMEA PA_ORCH_ORA2SF pa_matillion_master.ksh PALIGN EMEA_TEST EMEA_AE_FULL PFZALGN_EX_US_TEST PFZALGN_TEST_EMEA PA_ORCH_ORA2SF' "${jilFile}"
		sed -i 's/master_algn_dataloader.ksh ORACLE_EU PROD EMEA_DEV/master_algn_dataloader.ksh ORACLE_EU PROD EMEA_TEST/g' "${jilFile}"



    elif [ "${target_branch}" = "sit" ]; then
		# Replace string in the JIL file for the "sit" branch
		sed -i 's/d2compaemea/s2compaemea/g' "${jilFile}"
		sed -i 's/D2COMPAEMEA/S2COMPAEMEA/g' "${jilFile}"
		sed -i "s/$autosys_dev_server/$autosys_sit_server/g" "${jilFile}"
		# sed -i 's/pa_matillion_master\.ksh PALIGN EMEA_DEV \(.*\) PFZALGN_DEV PFZALGN_DEV/pa_matillion_master.ksh PALIGN TEST \1 PFZALGN_TEST PFZALGN_TEST/g' "${jilFile}"
		sed -i 's/pa_postgresql_master.ksh PALIGN EMEA_DEV/pa_postgresql_master.ksh PALIGN EMEA_SIT/g' "${jilFile}"
		# sed -i 's/pa_postgresql_master.ksh PALIGN DEV_IDL/pa_postgresql_master.ksh PALIGN TEST_IDL/g' "${jilFile}"
		# sed -i 's/pa_snowflake_master.ksh cometl_pa_ods_dev/pa_snowflake_master.ksh cometl_pa_ods_test/g' "${jilFile}"
		# sed -i 's/pa_sf_ae_load_status_check.ksh cometl_pa_ods_dev/pa_sf_ae_load_status_check.ksh cometl_pa_ods_test/g' "${jilFile}"
		#sed -i 's/master_batch_upload.ksh DEV/master_batch_upload.ksh TEST/g' "${jilFile}"
		# sed -i 's/master_cascade_notification.ksh DEV/master_cascade_notification.ksh TEST/g' "${jilFile}"
		sed -i 's/master_dataloader.ksh ORACLE_EU PROD EMEA_DEV/master_dataloader.ksh ORACLE_EU PROD EMEA_SIT/g' "${jilFile}"
		# sed -i 's/pa_file_transfer.ksh PALIGN DEV/pa_file_transfer.ksh PALIGN TEST/g' "${jilFile}"
		# sed -i 's/pa_file_purge.ksh PALIGN DEV/pa_file_purge.ksh PALIGN TEST/g' "${jilFile}"
		# sed -i 's/pa_snowflake_prevalidn_master.ksh cometl_pa_ods_dev/pa_snowflake_prevalidn_master.ksh cometl_pa_ods_test/g' "${jilFile}"
  		# sed -i 's/pa_sf_pub_prev_job_status_chk.ksh cometl_pa_ods_dev/pa_sf_pub_prev_job_status_chk.ksh cometl_pa_ods_test/g' "${jilFile}"
  		# sed -i 's/pa_autosys_job_dtls.ksh PALIGN DEV/pa_autosys_job_dtls.ksh PALIGN TEST/g' "${jilFile}"
		sed -i 's/machine: emeavopsfa00001/machine: emaaelp00010106/g' "${jilFile}"
		sed -i 's/owner: SRVAMR-PALIGN/owner: SRVAMR-PALIGNEM/g' "${jilFile}"
		sed -i 's/master_xref_refresh.ksh EMEA_DEV/master_xref_refresh.ksh EMEA_SIT/g' "${jilFile}"
		sed -i 's/pa_matillion_master.ksh PALIGN EMEA_DEV EMEA_AE_FULL PFZALGN_EX_US_DEV PFZALGN_DEV_EMEA PA_ORCH_ORA2SF pa_matillion_master.ksh PALIGN EMEA_SIT EMEA_AE_FULL PFZALGN_EX_US_SIT PFZALGN_SIT_EMEA PA_ORCH_ORA2SF' "${jilFile}"
		sed -i 's/master_algn_dataloader.ksh ORACLE_EU PROD EMEA_DEV/master_algn_dataloader.ksh ORACLE_EU PROD EMEA_SIT/g' "${jilFile}"



    elif [ "${target_branch}" = "uat" ]; then
		# Replace string in the JIL file for the "uat" branch
		sed -i 's/d2compaemea/u2compaemea/g' "${jilFile}"
		sed -i 's/D2COMPAEMEA/U2COMPAEMEA/g' "${jilFile}"
		sed -i "s/$autosys_dev_server/$autosys_uat_server/g" "${jilFile}"
		# sed -i 's/pa_matillion_master\.ksh PALIGN EMEA_DEV \(.*\) PFZALGN_DEV PFZALGN_DEV/pa_matillion_master.ksh PALIGN TEST \1 PFZALGN_TEST PFZALGN_TEST/g' "${jilFile}"
		sed -i 's/pa_postgresql_master.ksh PALIGN EMEA_DEV/pa_postgresql_master.ksh PALIGN EMEA_UAT/g' "${jilFile}"
		# sed -i 's/pa_postgresql_master.ksh PALIGN DEV_IDL/pa_postgresql_master.ksh PALIGN TEST_IDL/g' "${jilFile}"
		# sed -i 's/pa_snowflake_master.ksh cometl_pa_ods_dev/pa_snowflake_master.ksh cometl_pa_ods_test/g' "${jilFile}"
		# sed -i 's/pa_sf_ae_load_status_check.ksh cometl_pa_ods_dev/pa_sf_ae_load_status_check.ksh cometl_pa_ods_test/g' "${jilFile}"
		#sed -i 's/master_batch_upload.ksh DEV/master_batch_upload.ksh TEST/g' "${jilFile}"
		# sed -i 's/master_cascade_notification.ksh DEV/master_cascade_notification.ksh TEST/g' "${jilFile}"
		sed -i 's/master_dataloader.ksh ORACLE_EU PROD EMEA_DEV/master_dataloader.ksh ORACLE_EU PROD EMEA_UAT/g' "${jilFile}"
		# sed -i 's/pa_file_transfer.ksh PALIGN DEV/pa_file_transfer.ksh PALIGN TEST/g' "${jilFile}"
		# sed -i 's/pa_file_purge.ksh PALIGN DEV/pa_file_purge.ksh PALIGN TEST/g' "${jilFile}"
		# sed -i 's/pa_snowflake_prevalidn_master.ksh cometl_pa_ods_dev/pa_snowflake_prevalidn_master.ksh cometl_pa_ods_test/g' "${jilFile}"
  		# sed -i 's/pa_sf_pub_prev_job_status_chk.ksh cometl_pa_ods_dev/pa_sf_pub_prev_job_status_chk.ksh cometl_pa_ods_test/g' "${jilFile}"
  		# sed -i 's/pa_autosys_job_dtls.ksh PALIGN DEV/pa_autosys_job_dtls.ksh PALIGN TEST/g' "${jilFile}"
		sed -i 's/machine: emeavopsfa00001/machine: emaaelp00010116/g' "${jilFile}"
		sed -i 's/owner: SRVAMR-PALIGN/owner: SRVAMR-PALIGNEM/g' "${jilFile}"
		sed -i 's/master_xref_refresh.ksh EMEA_DEV/master_xref_refresh.ksh EMEA_UAT/g' "${jilFile}"
		sed -i 's/pa_matillion_master.ksh PALIGN EMEA_DEV EMEA_AE_FULL PFZALGN_EX_US_DEV PFZALGN_DEV_EMEA PA_ORCH_ORA2SF pa_matillion_master.ksh PALIGN EMEA_UAT EMEA_AE_FULL PFZALGN_EX_US_UAT PFZALGN_UAT_EMEA PA_ORCH_ORA2SF' "${jilFile}"
		sed -i 's/master_algn_dataloader.ksh ORACLE_EU PROD EMEA_DEV/master_algn_dataloader.ksh ORACLE_EU PROD EMEA_UAT/g' "${jilFile}"




    elif [ "${target_branch}" = "main" ]; then
		# Replace string in the JIL file for the "main" branch
		sed -i 's/d2compaus/p2compaus/g' "${jilFile}"
		sed -i 's/D2COMPAUS/P2COMPAUS/g' "${jilFile}"
		sed -i "s/$autosys_dev_server/$autosys_prod_server/g" "${jilFile}"
		sed -i 's/pa_matillion_master\.ksh PALIGN DEV \(.*\) PFZALGN_DEV PFZALGN_DEV/pa_matillion_master.ksh PALIGN PROD \1 PFZALGN PFZALGN/g' "${jilFile}"
		sed -i 's/pa_postgresql_master.ksh PALIGN DEV/pa_postgresql_master.ksh PALIGN PROD/g' "${jilFile}"
		sed -i 's/pa_snowflake_master.ksh cometl_pa_ods_dev/pa_snowflake_master.ksh cometl_pa_ods_prod/g' "${jilFile}"
		sed -i 's/pa_sf_ae_load_status_check.ksh cometl_pa_ods_dev/pa_sf_ae_load_status_check.ksh cometl_pa_ods_prod/g' "${jilFile}"
		sed -i 's/pa_postgresql_master.ksh PALIGN DEV_IDL/pa_postgresql_master.ksh PALIGN PROD_IDL/g' "${jilFile}"
		#sed -i 's/master_batch_upload.ksh DEV/master_batch_upload.ksh PROD/g' "${jilFile}"
		sed -i 's/master_cascade_notification.ksh DEV/master_cascade_notification.ksh PROD/g' "${jilFile}"
		sed -i 's/master_dataloader.ksh ORACLE PROD DEV_IDL/master_dataloader.ksh ORACLE PROD PROD_IDL/g' "${jilFile}"
		sed -i 's/pa_file_transfer.ksh PALIGN DEV/pa_file_transfer.ksh PALIGN PROD/g' "${jilFile}"
		sed -i 's/pa_file_purge.ksh PALIGN DEV/pa_file_purge.ksh PALIGN PROD/g' "${jilFile}"
		sed -i 's/pa_snowflake_prevalidn_master.ksh cometl_pa_ods_dev/pa_snowflake_prevalidn_master.ksh cometl_pa_ods_prod/g' "${jilFile}"
  		sed -i 's/pa_autosys_job_dtls.ksh PALIGN DEV/pa_autosys_job_dtls.ksh PALIGN PROD/g' "${jilFile}"
    		sed -i 's/pa_sf_pub_prev_job_status_chk.ksh cometl_pa_ods_dev/pa_sf_pub_prev_job_status_chk.ksh cometl_pa_ods_prod/g' "${jilFile}"

    fi

    # Perform the curl command
    response=$(curl -X POST -H 'Content-Type: text/plain' --upload-file "${jilFile}" "${autosys_apiEndpoint}" -k --user "${USERNAME}:${PASSWORD}" -i)
    
    # Print the response
    echo "Response: ${response}"
    
    # Extract the value of the "status" field from the JSON response
    statusMatch=$(echo "${response}" | grep -o '"status"\s*:\s*"[^"]*"' | awk -F'"' '{print $4}')
    
    if [ -n "${statusMatch}" ]; then
        if [ "${statusMatch}" = "failed" ]; then
            echo "Deployment of ${jilFile} failed"
            failedFiles+=("${jilFile}") # Add failed JIL file to the array
        else
            echo "Deployment of ${jilFile} successful"
            successfulFiles+=("${jilFile}") # Add successful JIL file to the array
        fi
    else
        echo "Unable to determine the status from the response"
        failedFiles+=("${jilFile}") # Assume failure if status extraction fails
    fi
done

if [ ${#failedFiles[@]} -gt 0 ]; then
    echo "Failed JIL files: ${failedFiles[@]}"
    exit 1 # Exit with a non-zero status to mark the script as failed
else
    echo "All JIL files deployed successfully"
fi

echo "Successful JIL files: ${successfulFiles[@]}"
