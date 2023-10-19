

pipeline {
    agent any
    environment{
	jilDirectory='/app/etl/palign/scripts/scripts_ui/python_scripts'
	apiEndpoint='https://amraelp00011055.pfizer.com:9443/AEWS/jil'
    }
    parameters {
        choice choices: ['No', 'Yes'], description: 'Mention if You want to Deploy into Autosys Environment', name: 'Deploy_to_Autosys'     
    }
    stages{
        
        stage ("Deploy to Autosys"){
            when {
                 expression { params.Deploy_to_Autosys == "Yes" }
            }
            steps{		
		// //prod server testing
		// sh "scp test.py srvamr-sfaops@amer@amraelp00011593:/tmp"
		    sh "echo test successful"
		//sh "ssh -i /var/lib/jenkins/.ssh/id_rsa srvamr-sfaops@amer@10.191.112.123 'sudo chmod 775 ${env.jilDirectory}/*'" 
		
		//sh "scp -i /var/lib/jenkins/.ssh/id_rsa test1.py srvamr-sfaops@amer@10.191.117.73:/app/etl/palign/scripts/scripts_ui/python_scripts"
		//sh "ssh -i /var/lib/jenkins/.ssh/id_rsa srvamr-sfaops@amer@10.191.117.73 'sudo chmod 775 /app/etl/palign/scripts/scripts_ui/python_scripts/*'"
		
		//sh "scp -i /var/lib/jenkins/.ssh/id_rsa test1.py srvamr-sfaops@amer@10.191.123.96:/app/etl/palign/scripts/scripts_ui/python_scripts"
		//sh "ssh -i /var/lib/jenkins/.ssh/id_rsa srvamr-sfaops@amer@10.191.123.96 'sudo chmod 775 /app/etl/palign/scripts/scripts_ui/python_scripts/*'"
		
		//sh "sudo ssh srvamr-sfaops@10.191.97.113 'chown srvamr-palign:unix-palign-u /app/etl/palign/scripts/scripts_ui/python_scripts/*'" 
		//grw testing
		//sh "scp -i /var/lib/jenkins/.ssh/id_rsa -r test.py  srvamr-sfaops@amer.pfizer.com@amrvlp000006956:/dt_pfizeraligndata/test/Scripts/CDW_CUST"
		//sh "ssh -i /var/lib/jenkins/.ssh/id_rsa srvamr-sfaops@amer.pfizer.com@amrvlp000006956 'dzdo chmod 775 /dt_pfizeraligndata/test/Scripts/CDW_CUST/*'"
		//sh "ssh -i /var/lib/jenkins/.ssh/id_rsa srvamr-sfaops@amer.pfizer.com@amrvlp000006956 'dzdo chown -R infadmd2:etl /dt_pfizeraligndata/test/Scripts/CDW_CUST/*'" 
		}
            
				
        }
    }
}
