# Automatically build and publish base images for balena managed devices

## AWS CodeBuild

### Creating AWS resources
Until we have a proper cloud formation script, the codebuild project and codepipeline projects have
to be created individually using the aws cli.

```
aws codebuild create-project --cli-input-json file://automation/create-project-cli-input.json
aws codepipeline create-pipeline --cli-input-json file://automation/codepipeline-create-pipeline-cli-input.json
```


To manually try:
```
./codebuild_build.sh -i aws/codebuild/standard:2.0 -a .
```
https://aws.amazon.com/blogs/devops/announcing-local-build-support-for-aws-codebuild/
https://github.com/aws-samples/aws-codebuild-custom-raspbian-builder
https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-create.html#pipelines-create-cli
