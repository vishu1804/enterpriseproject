#!groovy

import groovy.json.JsonSlurperClassic


node {
    
 
    def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
    def SF_USERNAME=env.SF_USERNAME
    def SERVER_KEY_CREDENTALS_ID=env.SERVER_KEY_CREDENTALS_ID
    def TEST_LEVEL='RunLocalTests'
    def PACKAGE_NAME='0Ho2x000000fxSVCAY'
    
    def PACKAGE_VERSION


    def toolbelt = tool 'toolbelt'
	def pmdtool = tool 'pmd'
    
    

    // -------------------------------------------------------------------------
    // Check out code from source control.
    // -------------------------------------------------------------------------

    stage('checkout source') {
       
        checkout scm 
       
    }


    // -------------------------------------------------------------------------
    // Run all the enclosed stages with access to the Salesforce
    // JWT key credentials.
    // -------------------------------------------------------------------------

    withCredentials([file(credentialsId: SERVER_KEY_CREDENTALS_ID, variable: 'server_key_file')]) {

        // -------------------------------------------------------------------------
        // Authorize the Dev Hub org with JWT key and give it an alias.
        // -------------------------------------------------------------------------

       
	    stage('Static Code Analysis') {
		    try
		    {
	    //echo 'Doing Code Review for Apex '
		  if (isUnix()) {
			  output = sh returnStdout: false, script: "${pmdtool}\\pmd -d force-app/main/default/classes -f html -R ApexRule.xml -failOnViolation false -reportfile CodeReviewAnalysisOutput.html"
              env.WORKSPACE = pwd()
              echo "${env.WORKSPACE}"
		  } else {
		   //bat(returnStdout: true, script: "${toolbelt}\\sfdx force:package:version:create --package ${PACKAGE_NAME} --installationkeybypass --wait 10 --json --targetdevhubusername DevHub").trim()
 
		      	    output = bat(returnStdout: false, script: "${pmdtool}\\pmd -d force-app/main/default/classes -f html -R ApexRule.xml -failOnViolation false -reportfile CodeReviewAnalysisOutput.html").trim()

			}
		  }
		catch(err)
            {
               // echo err.getMessage()
             //  echo 'error occured'
                
            }
	    }
	    
	    
       
        // -------------------------------------------------------------------------
        // Create package version.
        // -------------------------------------------------------------------------

        stage('Create Package Version') {
           
                    if (isUnix()) {
                        output = sh returnStdout: true, script: "${toolbelt}\\sfdx force:package:version:create --package ${PACKAGE_NAME} --installationkeybypass --wait 10 --json --targetdevhubusername DevHub"
                    } else {
                        output = bat(returnStdout: true, script: "${toolbelt}\\sfdx force:package:version:create --package ${PACKAGE_NAME} --installationkeybypass --wait 10 --json --targetdevhubusername DevHub").trim()
                        output = output.readLines().drop(1).join(" ")
            }


            // Wait 5 minutes for package replication.
            sleep 300
            
            try{
               // echo "Before json call"
             def jsonSlurper = new JsonSlurperClassic()
            def response = jsonSlurper.parseText(output)
//echo "Before Package creation"
            PACKAGE_VERSION = response.result.SubscriberPackageVersionId
            response = null

          //  echo ${PACKAGE_VERSION}
            }
            catch(err)
            {
                echo $err
                
            }
		    
          }
        // -------------------------------------------------------------------------
        // Authenticate Sandbox org to install package to.
        // -------------------------------------------------------------------------

        stage('Authorize Sandbox Org') {
          
            echo "Authenticate Sandbox Org to install package to"
            rc = command "${toolbelt}\\sfdx force:auth:sfdxurl:store -f package-sfdx-project.json -s -a QAOrg"
            //rc = command "${toolbelt}\\sfdx force:org:create --targetdevhubusername DevHub --setdefaultusername --definitionfile config/project-scratch-def.json --setalias installorg --wait 10 --durationdays 1"
            if (rc != 0) {
                error 'Authorization to Salesforce failed.'
            }
           
        }


       

        // -------------------------------------------------------------------------
        // Install package in Sandbox org.
        // -------------------------------------------------------------------------

        stage('Install Package In Sandbox Org') {
            
            rc = command "${toolbelt}\\sfdx force:package:install --targetusername QAOrg --package ${PACKAGE_VERSION} --wait 10 --publishwait 10 --noprompt --json"
            // rc = command "${toolbelt}\\sfdx force:package:install --package ${PACKAGE_VERSION} --targetusername installorg --wait 10"
		    if (rc != 0) {
			error 'Salesforce package install failed.'
		    }
            }
	stage('Production Deployment Approval'){
    		input 'Do you want to deploy package to Production?'
		}
	stage('Authorize Production'){
		echo "Authenticate Sandbox Org to install package to"
		rc = command "${toolbelt}\\sfdx force:auth:sfdxurl:store -f package-sfdx-project.json -s -a ProdOrg"
		 if (rc != 0) {
                	error 'Authorization to Production failed.'
            		}
    		}
    	stage('Install Package to Production'){
        	rc = command "${toolbelt}\\sfdx force:package:install --targetusername ProdOrg --package ${PACKAGE_VERSION} --wait 10 --publishwait 10 --noprompt --json"
        		if (rc != 0) {
                		error 'Salesforce package install failed.'
            			}
    		}
        }    

    
    
}



def command(script) {
    if (isUnix()) {
        return sh(returnStatus: true, script: script);
    } else {
        return bat(returnStatus: true, script: script);
    }
}
