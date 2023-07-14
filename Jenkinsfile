

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
		 sh "scp -r test.py srvamr-sfaops@10.191.97.113:/app/etl/palign/scripts/scripts_ui/python_scripts/"
		//sh "scp -r test.py srvamr-sfaops@10.191.112.123:/tmp"   
		//sh "scp -r test.py srvamr-sfaops@10.191.117.73:/tmp" 
		//sh "scp -r test.py srvamr-sfaops@10.191.123.96:/tmp" 
                //sh "ssh srvamr-sfaops@10.191.112.123 'chmod -R 775 /app/etl/palign/scripts/scripts_ui/python_scripts/'"
		//sh "ssh srvamr-palig@10.191.97.113 'ls /app/etl/palign/scripts/scripts_ui/python_scripts/'"
		sh "ssh srvamr-sfaops@10.191.97.113 'chmod -R 775 /app/etl/palign/scripts/scripts_ui/python_scripts/'"   
		sh "ssh srvamr-sfaops@10.191.97.113 'chown srvamr-palign:unix-palign-u /app/etl/palign/scripts/scripts_ui/python_scripts/'" 
		//sh "ssh srvamr-sfaops@10.191.117.73 'chmod -R 775 /tmp/test.py'"
		//sh "ssh srvamr-sfaops@10.191.123.96 'chmod -R 775 /tmp/test.py'"
		}
            
				
        }
    }
}
