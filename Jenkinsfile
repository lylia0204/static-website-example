pipeline {

    environment {
        IMAGE_NAME = "static_website"
        EC2_PRODUCTION_HOST = "18.224.165.147"
        USERNAME = "lilya0204"
        CONTAINER_NAME = "static_website"
    }

      agent none

    stages{

       stage ('Build Image'){
           agent any
           steps {
               script{
                   sh 'docker build -t $USERNAME/$IMAGE_NAME:$BUILD_TAG .'
               }
           }
       }

       stage ('Run test container') {
           agent any
           steps {
               script{
                   sh '''
                       docker stop $CONTAINER_NAME || true
                       docker rm $CONTAINER_NAME || true
                       docker run --name $CONTAINER_NAME -d -p 5000:80 $USERNAME/$IMAGE_NAME:$BUILD_TAG
                       sleep 6
                   '''
               }
           }
       }

       stage ('Test container') {
           agent any
           steps {
               script{
                   sh '''
                       curl http://localhost:5000 | grep -iq "Lylia"
                   '''
               }
           }
       }

       stage ('clean env and save artifact') {
           agent any
           environment{
               PASSWORD = credentials('dockerhub_password')
           }
           steps {
               script{
                   sh '''
                       docker login -u $USERNAME -p $PASSWORD
                       docker push $USERNAME/$IMAGE_NAME:$BUILD_TAG
                       docker stop $CONTAINER_NAME || true
                       docker rm $CONTAINER_NAME || true
                       docker rmi $USERNAME/$IMAGE_NAME:$BUILD_TAG
                   '''
               }
           }
       }


        stage('Deploy app on EC2-cloud Production') {
        agent any
        when{
            expression{ GIT_BRANCH == 'origin/mini-projet-jenkins'}
        }
        steps{
            withCredentials([sshUserPrivateKey(credentialsId: "ec2_prod_private_key", keyFileVariable: 'keyfile', usernameVariable: 'NUSER')]) {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script{ 
                        
                        timeout(time: 15, unit: "MINUTES") {
                            input message: 'Do you want to approve the deploy in production?', ok: 'Yes'
                        }

                        sh'''
                                ssh -o StrictHostKeyChecking=no -i ${keyfile} ${NUSER}@${EC2_PRODUCTION_HOST} docker stop $CONTAINER_NAME || true
								ssh -o StrictHostKeyChecking=no -i ${keyfile} ${NUSER}@${EC2_PRODUCTION_HOST} docker rm $CONTAINER_NAME || true
								ssh -o StrictHostKeyChecking=no -i ${keyfile} ${NUSER}@${EC2_PRODUCTION_HOST} docker run --name $CONTAINER_NAME -d  -p 5000:80 $USERNAME/$IMAGE_NAME:$BUILD_TAG
                        '''
                    }
                }
            }
        }
        }
    }
    post {
        success{
            slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
        failure {
            slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
    }
}
