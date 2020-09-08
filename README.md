# Automatically build and publish base images for balena managed devices

## AWS CodeBuild

### Creating AWS resources
Until we have a proper cloud formation script, the codebuild project and codepipeline projects have
to be created individually using the aws cli.

```
aws codebuild create-project --cli-input-json file://automation/codebuild-create-project-cli-input.json
aws codepipeline create-pipeline --cli-input-json file://automation/codepipeline-create-pipeline-cli-input.json
```

### Local testing
There is a way to emulate many parts of the aws codebuild. It involves building the aws container first on the local dev
system, and then running the codebuild_build.sh script
This link has detailed explanations. Note that features such as secrets might need more setup to work proberly
https://aws.amazon.com/blogs/devops/announcing-local-build-support-for-aws-codebuild/

```
./codebuild_build.sh -i aws/codebuild/standard:2.0 -a .
```
### Useful commands for local development
```
docker build -t motesque/scopethemove-raspberrypi3-debian:dev  --build-arg ARCH=raspberrypi3  .
docker build -t motesque/scopethemove-amd64-debian:dev  --build-arg ARCH=amd64  .
```