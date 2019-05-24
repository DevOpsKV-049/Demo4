def label = "mypod"


properties([parameters([choice(choices: ['terraform apply', 'terraform destroy'], description: 'apply', name: 'apply')])])

podTemplate(label: label, containers: [
  containerTemplate(name: 'python3', image: 'python:3', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'terraform', image: 'hashicorp/terraform', command: 'cat', ttyEnabled: true),
  //containerTemplate(name: 'monitoring', image: 'lachlanevenson/k8s-helm', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'monitoring', image: 'denizka/myhelpcont', command: 'cat', ttyEnabled: true)
])
{


    node(label){
        try {
            withCredentials([file(credentialsId: 'terraform', variable: 'GOOGLE_CREDENTIALS'),
                                 string(credentialsId: 'TF_VAR_password', variable: 'TF_VAR_password'),
                                 string(credentialsId: 'TF_VAR_api_telegram', variable: 'TF_VAR_api_telegram'),
                                 string(credentialsId: 'TF_VAR_MONGODB_PASSWORD', variable: 'TF_VAR_MONGODB_PASSWORD'),
                                 string(credentialsId: 'TF_VAR_API', variable: 'TF_VAR_API'),
                                 string(credentialsId: 'TF_VAR_bucket', variable: 'TF_VAR_bucket'),
                                 string(credentialsId: 'TF_VAR_project', variable: 'TF_VAR_project'),
				 string(credentialsId: 'TF_VAR_REDIS_PASSWORD', variable: 'TF_VAR_REDIS_PASSWORD'),
				 string(credentialsId: 'TF_VAR_jtoken', variable: 'TF_VAR_jtoken'),
				string(credentialsId: 'TF_VAR_r_pass', variable: 'TF_VAR_r_pass'),
                                 string(credentialsId: 'TF_VAR_MONGODB_ROOT_PASSWORD', variable: 'TF_VAR_MONGODB_ROOT_PASSWORD')
                             ]) {


                    stage('Checkout repo'){
                        checkout([$class: 'GitSCM', branches: [[name: '*/master']],
                            userRemoteConfigs: [[url: 'https://github.com/denizka1991/demo3.1.git']]])
                        }


                    stage('Checkout Terraform') {
                        container('terraform'){

                        //set SECRET with the credential content
                            sh 'ls -al $GOOGLE_CREDENTIALS'
                            sh 'mkdir -p creds'
                            sh "cp \$GOOGLE_CREDENTIALS ./creds/monitoringtest-239812-8eb299494e3f.json"
                         //   sh "cat creds/test.json"
                            sh 'terraform init'
                            sh 'terraform plan -out myplan'
                           // sh 'terraform apply -auto-approve -input=false myplan'
                            //sh 'terraform destroy -auto-approve -input=false'
                        }
                    }

                if (params.apply == 'terraform destroy') {
                    stage('Destroy Terraform') {
                        container('terraform'){
                            sh 'terraform destroy -auto-approve -input=false'
                        }
                        }
                }
                else{
                    stage("Run unit tests"){
                        container("python3"){
                            sh "pip3 install -r ./functions/requirements.txt"
                            sh "python3 --version"
                            sh "python3 ./functions/app/test.py"
                            sh "python3 ./functions/currentTemp/test.py"
                            sh "python3 ./functions/getFromDB/test.py"
                            sh "python3 ./functions/getPredictions/test.py"
                            sh "python3 ./functions/saveToDB/test.py"
                            sh "python3 ./functions/toZamb/test.py"
                            //sh "python3 ./functions/zamb/test.py"
                        }
                    }


                    stage('Apply Terraform') {
                        container('terraform'){
                             sh 'terraform apply -auto-approve -input=false myplan'
                             }
                        }


                    stage('Install monitoring tools') {
                        container("monitoring"){
		  //    sh 'cat /etc/host'
                  //    sh '/root/google-cloud-sdk/bin/gcloud beta container clusters get-credentials k8s-dev-cluster --region us-central1 --project monitoringtest-239812'        
		  //    sh '/usr/local/bin/helm init'
		  //    sh '/usr/local/bin/helm repo update'
		  //    sh '/usr/local/bin/helm dep update ./ita-monitoring'
                   // sh 'kubectl create clusterrolebinding tiller --clusterrole cluster-admin -serviceaccount=kube-system:default'
		    //  sh "/usr/local/bin/helm upgrade --install monitoring --namespace monitoring ./ita-monitoring"
		  //    sh 'helm delete --purge monitoring'
			sh "ssh -i /home/.ssh/id_rsa hdenizka@35.232.135.86 './test.sh'"	
                             }
                        }
                    }

                }
            }

        catch(err){
            currentBuild.result = 'Failure'
        }
    }
}
