#!bin/bash
pushd .  > /dev/null
rm -rf ./tmp
# the
# https://www.ecliptik.com/Cross-Building-and-Running-Multi-Arch-Docker-Images/#qemu-on-linux
# apt-getinstall -y qemu qemu-user-static qemu-user binfmt-support
REVISION=j
CONTAINER=$1
echo "Building Container '$CONTAINER', Revision:'$REVISION',"
#platforms=( "raspberrypi3" "amd64" "imx8m-var-dart"  )
platforms=( "amd64" )
for pl in "${platforms[@]}"
do
    pushd .  > /dev/null
    mkdir -p ./tmp/$CONTAINER/$pl/
    cp ./containers/$CONTAINER/requirements.txt ./tmp/$CONTAINER/$pl/
    python3 configure.py ./containers/$CONTAINER/Dockerfile.in --platform $pl > ./tmp/$CONTAINER/$pl/Dockerfile
    cd ./tmp/$CONTAINER/$pl/
    DOCKER_TAG=$(grep FROM Dockerfile | tail -n 1 | cut -d : -f 2)$REVISION
    echo "Building docker image 'motesque/$CONTAINER/$pl-debian:${DOCKER_TAG}'"
    docker build -t motesque/$CONTAINER/$pl-debian:${DOCKER_TAG} .
    echo docker build -t motesque/$CONTAINER/$pl-debian:${DOCKER_TAG} .
    popd  > /dev/null
done
popd  > /dev/null

echo "Validating installed packages..."
for pl in "${platforms[@]}"
do
    docker run --rm motesque/$CONTAINER/$pl-debian:${DOCKER_TAG} pip3 list > ./tmp/installed_packages_${CONTAINER}_$pl.txt
    echo "Retrieved installed packet list from 'motesque/$CONTAINER/$pl-debian:${DOCKER_TAG}'"
done

echo "Diff'ing..."
diff3 ./tmp/installed_packages_${CONTAINER}_raspberrypi3.txt ./tmp/installed_packages_${CONTAINER}_amd64.txt ./tmp/installed_packages_${CONTAINER}_imx8m-var-dart.txt &> ./tmp/${CONTAINER}_diff_result.txt
if [[ -s ./tmp/${CONTAINER}_diff_result.txt ]]
then
    echo "ERROR - Packet versions across docker base images do not match. Please check."
else
    dockerUsr=`cat /var/lib/jenkins/dockerhub.credentials | cut -d: -f1`
    #dockerPwd=`cat /var/lib/jenkins/dockerhub.credentials | cut -d: -f2`
    echo "OK - Packet version match across all docker base images. Well done!"
    echo "     Publishing..."
    cat /var/lib/jenkins/dockerhub.credentials | cut -d: -f2 | docker login -u ${dockerUsr} --password-stdin
    for pl in "${platforms[@]}"
    do
        docker push motesque/${CONTAINER}/$pl-debian:${DOCKER_TAG}
    done
fi
