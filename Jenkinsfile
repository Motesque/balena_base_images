/*

Jenkinsfile 
scopethemove

*/

node {
        cleanWs()
        checkout scm
        sh 'sudo -n /bin/rm -rf /var/lib/jenkins/workspace/balena_base_images_*_ws-cleanup_*'
        sh 'cd containers/scopethemove && . ./build.sh'
        
}


