pipeline {
  //agent any
  agent {
  docker { 
            image 'sravangcpdocker/terraform:2'
            args '-u root:root'
        }
        }
  stages {
    stage('Hello') {
      steps {
        sh '''
            git clone https://github.com/sravan-github/terraformgcp.git
            ls -l
            pwd
            terraform --version
            #export GOOGLE_APPLICATION_CREDENTIALS="./gcp-key.json"
            #terraform init
            #terraform plan
            #terraform apply --auto-approve
            '''
      }
    }
  }
  post {
        always {
        	cleanWs deleteDirs: true
        }
    }
}
