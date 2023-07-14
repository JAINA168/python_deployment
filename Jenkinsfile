

pipeline {
    agent any
    environment{
	jilDirectory='Autosys'
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
		//sh "scp -i /var/lib/jenkins/.ssh/id_rsa test.py srvamr-sfaops@amer@10.191.97.113:/app/etl/palign/scripts/scripts_ui/python_scripts"
		//sh "sudo ssh srvamr-sfaops@amer@10.191.97.113 'chmod 775 /app/etl/palign/scripts/scripts_ui/python_scripts/*'"   
		//sh "sudo ssh srvamr-sfaops@10.191.97.113 'chown srvamr-palign:unix-palign-u /app/etl/palign/scripts/scripts_ui/python_scripts/*'" 
		sh "scp -i /var/lib/jenkins/.ssh/id_rsa -r test.py  srvamr-sfaops@amer.pfizer.com@amrvlp000006956:/dt_pfizeraligndata/test/Scripts/CDW_CUST"
		sh "ssh -i /var/lib/jenkins/.ssh/id_rsa srvamr-sfaops@amer.pfizer.com@amrvlp000006956 'dzdo chmod 775 /dt_pfizeraligndata/test/Scripts/CDW_CUST/*'"
		sh "ssh -i /var/lib/jenkins/.ssh/id_rsa srvamr-sfaops@amer.pfizer.com@amrvlp000006956 'dzdo chown -R infadmd2:etl /dt_pfizeraligndata/test/Scripts/CDW_CUST/*'" 
		}
            
				
        }
    }
}
