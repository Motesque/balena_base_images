/*

Jenkinsfile 
scopethemove

*/

node {
        cleanWs()
        checkout scm
        sh 'sudo -n /bin/rm -rf /var/lib/jenkins/workspace/balena_base_images_*_ws-cleanup_*'
        sh '. ./build.sh'
        sh 'mkdir -p ${WORKSPACE}/packages'
        sh 'find  ${WORKSPACE} -iname pkg_*.tar.gz -exec cp {} ${WORKSPACE}/packages/ \\;'
        archiveArtifacts 'packages/*.tar.gz'
  		sshPublisher(publishers: [sshPublisherDesc(configName: 'nyc3-download-01.motesque.com/scopethemove', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: 'packages/', sourceFiles: 'packages/*.tar.gz')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
}


