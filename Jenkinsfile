/*

Jenkinsfile 
balena-base-images

*/
pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                cleanWs()
                checkout scm
            }
        }
        stage('Build-amd64') {
            steps {
                sh 'automation/jenkins_build.sh amd64 scopethemove'
                sh 'automation/jenkins_build.sh amd64 scopethemove_db'
                sh 'automation/jenkins_build.sh amd64 ottobock'
            }
        }
        stage('Build-raspberrypi3') {
            steps {
                sh 'automation/jenkins_build.sh raspberrypi3 scopethemove'
                sh 'automation/jenkins_build.sh raspberrypi3 scopethemove_db'
                sh 'automation/jenkins_build.sh raspberrypi3 ottobock'
            }
        }
        stage('Build-imx8m-var-dart') {
            steps {
                sh 'automation/jenkins_build.sh imx8m-var-dart scopethemove'
                sh 'automation/jenkins_build.sh imx8m-var-dart scopethemove_db'
                sh 'automation/jenkins_build.sh imx8m-var-dart ottobock'
            }
        }
        stage('Test Packet Versions') {
            steps {
                sh 'automation/jenkins_validate.sh scopethemove'
                sh 'automation/jenkins_validate.sh scopethemove_db'
                sh 'automation/jenkins_validate.sh ottobock'
            }
        }
         stage('Publish to DockerHub') {
            steps {
                sh 'automation/jenkins_publish.sh scopethemove'
                sh 'automation/jenkins_publish.sh scopethemove_db'
                sh 'automation/jenkins_publish.sh ottobock'
            }
        }

    }
}