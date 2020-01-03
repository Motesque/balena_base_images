# Automatically build and publish base images for balena managed devices

## AWS CodeBuild

To manually try:
https://aws.amazon.com/blogs/devops/announcing-local-build-support-for-aws-codebuild/
```./codebuild_build.sh -i aws/codebuild/standard:2.0 -b buildspec-rpi3.yml -a .```
https://github.com/aws-samples/aws-codebuild-custom-raspbian-builder