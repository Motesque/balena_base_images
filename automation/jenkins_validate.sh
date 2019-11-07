# carry over the revision as it is specified in the jenkins_build.sh
REVISION=$(grep REVISION= $WORKSPACE/automation/jenkins_build.sh | cut -d = -f 2)
CONTAINER=$1
diff -q --from-file $WORKSPACE/validation/${CONTAINER}/installed_packages_amd64.txt  $WORKSPACE/validation/${CONTAINER}/installed_packages_raspberrypi3.txt
rc_diff=$?
if [[ $rc_diff != "0" ]]
then
    echo "ERROR - Packet versions across docker base images do not match. Please check."
else
    echo "OK - Packet version match across all docker base images. Well done!"
fi
exit $rc_diff