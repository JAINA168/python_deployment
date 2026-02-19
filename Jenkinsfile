import java.net.URLEncoder
@Library('sfdi-devops-tools-infra') _

pipeline {
    agent any
    environment {
        autosys_main_server = 'emaaelp00010116'
        jilDirectory = 'python_scripts'
        autosys_apiEndpoint = 'https://amraelp00011055.pfizer.com:9443/AEWS/jil'
        unix_server = "emaaelp00010116"
        unix_src_path_scripts = "python_scripts"
        unix_deploy_path_scripts = "/tmp"
        unix_service_account = "srvamr-sfaops@amer"
        unix_permission = "775"
        snowflake_db_url = "${getProperty("${env.BRANCH_NAME}_gitsync_test")}"
        snowflake_credid = "dev_central_emea_creds"
        snowflake_sync_schemas = "COMETL_SFDC_CONTROL COMETL_SFDC_STAGING COMETL_SFDC_SYNC COMETL_SFDC_REPLICATION COMETL_SFDC_LANDING"
        snowflake_changeLogFile = "snowflake/changelog.sf.xml"
        priv_key_path = "/var/lib/jenkins/.ssh/palign_id_rsa"
    }
    parameters {
        choice choices: ['No', 'Yes'], description: 'Mention if You want to Deploy into Autosys Environment', name: 'Deploy_to_Autosys'
        choice choices: ['No', 'Yes'], description: 'Mention if You want to Deploy into Snowflake Environment', name: 'Deploy_to_Snowflake'
        choice choices: ['No', 'Yes'], description: 'Mention if You want to Deploy into Unix Environment', name: 'Deploy_to_Unix'
        choice choices: ['Yes', 'No'], description: 'Mention if You want to Dry Run', name: 'dry_run'
        choice(name: 'Sync_From_DB', choices: ['No', 'Yes'], description: 'Auto-fetch new DDLs from Snowflake Dev to Git?')
        string(name: 'Deploy_Labels', defaultValue: '', description: 'Provide Liquibase labels for selective deployment. Leave blank to deploy all.')
        choice choices: ['No', 'Yes'], description: 'If you want to send alerts', name: 'Email_Alert'
        string defaultValue: 'None', description: 'Provide the comma separated Email addresses.', name: 'Notify_to'
    }
    stages {
        stage("Deploy to Unix") {
            when {
                expression { params.Deploy_to_Unix == "Yes" }
            }
            steps {
                script {
                    if (params.dry_run == 'Yes') {
                        sh "ls ${unix_src_path_scripts}"
                        return // Exit the script
                    }
                    sh "echo test successful"
                    // sh "scp -i ${priv_key_path} -r ${unix_src_path_scripts}/* ${unix_service_account}@${unix_server}:${unix_deploy_path_scripts}"
                }
            }
        }
 
        stage("Sync Incremental Changes to Git") {
            when {
                expression { params.Sync_From_DB == 'Yes' }
            }
            steps {
                script {
                    println "Generating Liquibase diff files for schemas using Dev DB offline snapshots..."
                    withCredentials([
                        usernamePassword(credentialsId: "${env.snowflake_credid}", passwordVariable: 'DEV_PASS', usernameVariable: 'DEV_USER'),
                        usernamePassword(credentialsId: 'SRVAMR-COMMGIT', usernameVariable: 'USER', passwordVariable: 'PASS')
                    ]) {
                        env.encodedGitPass = URLEncoder.encode(PASS, "UTF-8")
                        sh """
                            #!/bin/bash
                            TIMESTAMP=\$(date +"%Y%m%d_%H%M")
                            CHANGES_DETECTED=false
                            read -r -a SCHEMAS <<< "${env.snowflake_sync_schemas}"
                            git config user.name "\${USER}"
                            git config user.email "\${USER}@pfizer.com"
                            mkdir -p snowflake/snapshots
                            mkdir -p snowflake/ddls
                            for SCHEMA in "\${SCHEMAS[@]}"; do
                                echo "Processing schema: \$SCHEMA..."
                                SNAPSHOT_FILE="snowflake/snapshots/\${SCHEMA}_state.json"
                                DIFF_FILE="snowflake/ddls/\${TIMESTAMP}_\${SCHEMA}_diff.sql"
                                FULL_JDBC_URL="${env.snowflake_db_url}&schema=\$SCHEMA"
                                if [ ! -f "\$SNAPSHOT_FILE" ]; then
                                    echo "Creating baseline snapshot for \$SCHEMA..."
                                    liquibase --url="\$FULL_JDBC_URL" --username="\${DEV_USER}" --password="\${DEV_PASS}" snapshot --snapshotFormat=json --outputFile="\$SNAPSHOT_FILE"
                                    git add "\$SNAPSHOT_FILE"
                                    CHANGES_DETECTED=true
                                    continue
                                fi
                                echo "Comparing Live DEV DB against Git snapshot for \$SCHEMA..."
                                liquibase --url="\$FULL_JDBC_URL" --username="\${DEV_USER}" --password="\${DEV_PASS}" diffChangeLog --referenceUrl="offline:snowflake?snapshot=\$SNAPSHOT_FILE" --changeLogFile="\$DIFF_FILE" --format=sql --diffTypes="tables,views,columns,indexes,sequences"
                                if [ -s "\$DIFF_FILE" ] && grep -qi "CREATE\\|ALTER\\|DROP" "\$DIFF_FILE"; then
                                    echo "Incremental changes found in \$SCHEMA!"
                                    liquibase --url="\$FULL_JDBC_URL" --username="\${DEV_USER}" --password="\${DEV_PASS}" snapshot --snapshotFormat=json --outputFile="\$SNAPSHOT_FILE"
                                    git add "\$DIFF_FILE"
                                    git add "\$SNAPSHOT_FILE"
                                    CHANGES_DETECTED=true
                                else
                                    rm -f "\$DIFF_FILE"
                                fi
                            done
                            if [ "\$CHANGES_DETECTED" = true ]; then
                                echo "Committing DDLs and updated snapshots..."
                                git commit -m "Auto-sync: Incremental DDL changes from Dev DB [\$TIMESTAMP]"
                                git push https://\${USER}:${env.encodedGitPass}@\${params.git_repository.replace('https://','')} HEAD:${env.BRANCH_NAME}
                                echo "Successfully pushed to GitHub!"
                            else
                                echo "No database differences found across the schemas."
                            fi
                        """
                    }
                }
            }
        }
 
        stage("Deploy to Snowflake") {
            when {
                expression { params.Deploy_to_Snowflake == "Yes" }
            }
            steps {
                script {
                    if (params.Deploy_Labels && params.Deploy_Labels.trim() != "") {
                        env.LIQUIBASE_LABELS = params.Deploy_Labels
                        println "Applying Liquibase Labels for Selective Deployment: ${env.LIQUIBASE_LABELS}"
                    } else {
                        env.LIQUIBASE_LABELS = "" // Deploy all if blank
                    }
                    println "Deploying into Snowflake ${env.BRANCH_NAME} environment"
                    snowflake_deploy(url: snowflake_db_url, cred: snowflake_credid, changelog: snowflake_changeLogFile, dry_run: dry_run)
                }
            }
        }
 
        stage("Deploy to Autosys") {
            when {
                expression { params.Deploy_to_Autosys == "Yes" }
            }
            steps {
                sh 'chmod +x devops_scripts/autosys_deploy.sh'
                withCredentials([usernamePassword(credentialsId: 'sfaops', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    script {
                        env.PASSWORD = sh(script: "echo \$PASSWORD", returnStdout: true).trim()
                        env.USERNAME = sh(script: "echo \$USERNAME", returnStdout: true).trim()
                    }
                    sh "devops_scripts/autosys_deploy.sh"
                }
            }
        }
    }
 
    post {
        failure {
            notification_email(Email_Alert: Email_Alert, Notify_to: Notify_to)
        }
        success {
            notification_email(Email_Alert: Email_Alert, Notify_to: Notify_to)
        }
    }
}
