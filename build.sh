#!bin/bash
pushd .  > /dev/null
rm -rf ./tmp
# the
# https://www.ecliptik.com/Cross-Building-and-Running-Multi-Arch-Docker-Images/#qemu-on-linux
# apt-getinstall -y qemu qemu-user-static qemu-user binfmt-support
REVISION=h
echo "Building Revision '$REVISION'"
platforms=( "raspberrypi3" "amd64" "imx8m-var-dart"  )
for pl in "${platforms[@]}"
do
    pushd .  > /dev/null
    echo "Building docker image 'motesque/$pl-debian:${DOCKER_TAG}'"
    mkdir -p ./tmp/$pl/
    cp ./requirements_py3.txt ./tmp/$pl/
    python3 configure.py Dockerfile.in --platform $pl > ./tmp/$pl/Dockerfile
    cd ./tmp/$pl/
    DOCKER_TAG=$(grep FROM Dockerfile | cut -d : -f 2)$REVISION
    docker build -t motesque/$pl-debian:${DOCKER_TAG} .
    echo docker build -t motesque/$pl-debian:${DOCKER_TAG} .
    popd  > /dev/null
done
popd  > /dev/null

echo "Validating installed packages..."
for pl in "${platforms[@]}"
do
    docker run --rm motesque/$pl-debian:${DOCKER_TAG} pip3 list > ./tmp/installed_packages_$pl.txt
    echo "Retrieved installed packet list from 'motesque/$pl-debian:${DOCKER_TAG}'"
done

echo "Diff'ing..."
diff3 ./tmp/installed_packages_raspberrypi3.txt ./tmp/installed_packages_amd64.txt ./tmp/installed_packages_imx8m-var-dart.txt &> ./tmp/diff_result.txt
if [[ -s ./tmp/diff_result.txt ]]
then
    echo "ERROR - Packet versions across docker base images do not match. Please check."
else
    dockerUsr=`cat /var/lib/jenkins/dockerhub.credentials | cut -d: -f1`
    dockerPwd=`cat /var/lib/jenkins/dockerhub.credentials | cut -d: -f2`
    #echo "OK - Packet version match across all docker base images. Well done!"
    #echo "  To publish, execute"
    docker login -u ${dockerUsr} -p ${dockerPwd}
    for pl in "${platforms[@]}"
    do
        docker push motesque/$pl-debian:${DOCKER_TAG}
    done

fi

