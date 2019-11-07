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
            }
        }
        stage('Build-raspberrypi3') {
            steps {
                sh 'automation/jenkins_build.sh raspberrypi3 scopethemove'
            }
        }
        stage('Test Packet Versions') {
            steps {
                sh 'automation/jenkins_validate.sh scopethemove'
            }
        }
         stage('Publish to DockerHub') {
            steps {
                sh 'automation/jenkins_publish.sh scopethemove'
            }
        }

    }
}