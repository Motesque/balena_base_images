# Automatically build and publish base images for balena managed devices

## AWS CodeBuild

To manually try:
https://aws.amazon.com/blogs/devops/announcing-local-build-support-for-aws-codebuild/
```./codebuild_build.sh -i aws/codebuild/standard:2.0 -a .
aws codebuild create-project --cli-input-json file://automation/create-project-cli-input.json\
aws codepipeline create-pipeline --cli-input-json file://automation/codepipeline-create-pipeline-cli-input.json
```
https://github.com/aws-samples/aws-codebuild-custom-raspbian-builder
https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-create.html#pipelines-create-cli
