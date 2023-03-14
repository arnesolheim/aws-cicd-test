# aws-cicd-test

This is an example AWS-based CI/CD setup with focus on testing. The way it is designed is that you yourself can define the CI/CD pipeline, how the build should be performed, how the tests should be performed, etc. - without having to clone and/or alter the original project that you would like to build (and create tests for).

The way this example works is that it is using two parallell sources as input to the build pipeline; one source where you can define the build- and test-specifications, and another source which is the (then unaltered and "out of the box") project that you would like to build and test.

Feel free to fork and tamper/play with this example. The way it is currently tested is that the build- and test-configuration is set up in this project itself; see the "`codebuild/buildspec.yaml`" file (and of course you could add any number of additional build spec files that you would like; the CI/CD pipeline is set up to have the build spec reference as an input parameter).

Since this project itself will be one of the source inputs to the CI/CD pipeline you could then also add any other artifacts, scripts and other code as parts of the project; these will then also be downloaded and made available to you within the build pipeline itself.

* All files from this project will be available within your build stage as a directory whose path will be present in the environment variable "`$CODEBUILD_SRC_DIR`"
* All files from the other "third party" project that you would like to build will be available within your build stage as a directory whose path will be present in the environment variable "`$CODEBUILD_SRC_DIR_source2`"

## Setting up the CI/CD pipeline using AWS CloudFormation

We want to be using automation and Infrastucture as Code (IaC) to set up our CI/CD pipeline.
We have a corresponding AWS CloudFormation template ("`cloudformation/codepipeline-2x-github-codebuild.yaml`") that can be used to create a CloudFormation stack that will create and configure all necessary resources (CodePipeline, CodeBuild, etc.).

### Example

In this example we are setting things up for building the project located in the GitHub repository https://github.com/it-vegard/a11y-reference-website

Example stack name: "cicd-for-a11y-reference-website"
Example parameters to use when creating the AWS CloudFormation stack based on the template:

| Parameter  | Second Value |
| ------------- | ------------- |
|GitHubRepositoryOwner1|arnesolheim|
|GitHubRepositoryName1|aws-cicd-test|
|GitHubBranch1|main|
|GitHubRepositoryOwner2|it-vegard|
|GitHubRepositoryName2|a11y-reference-website|
|GitHubBranch2|master|
|PipelineName|cicd-for-a11y-reference-website|

---

## Testing the build directly on an EC2 instance (for lower roundtripe times)
To be able to shorten the round trip time when doing iterative testing on changes that you do on some Build Spec file you could start up an EC2 instance and perform the build locally there with the same build image as CodeBuild would use. To be able to do this you first create the EC2 instance (automated - through Infrastructure as Code of course - using CloudFormation), and then you can log into this instance and perform the build locally there.

### Setting up the EC2 instance
You can use the CloudFormation template "`cloudformation/ec2-instance-for-local-build-testing.yaml`" for creating the EC2 instance.

Example stack name: "ec2-instance-for-local-build-testing"
Example parameters to use when creating the AWS CloudFormation stack based on the template:

| Parameter  | Second Value |
| ------------- | ------------- |
|InstanceType|t3.small|
|InstanceName|ec2-instance-for-local-build-testing|
|VpcId|_&lt;Select desired VPC from the dropdown menu&gt;_|

### Connecting to the EC2 instance
You have two ways of connecting to the EC2 instance; either through regular SSH, or through Systems Manager Session Manager (recommended).
For the latter option you first [install the Session Manager plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html), and then after that you can use the AWS CLI for connecting.

Example:
```
aws ssm start-session --target <instance-id> --profile <aws-cli-profile-name> --region <aws-region>
```

If you want to connect to the EC2 instance using regular SSH you first need to open up in the Security Group for ingress traffic from your local IP address towards the EC2 instance (Alter the "`InstanceSecurityGroup`" resource in the CloudFormation template for this and update the stack), and then obtain the private key part of the key pair. The private key part can be found in AWS Systems Manager Parameter Store using a parameter with the following name: "`/ec2/keypair/<key_pair_id>`", where the "`<key-pair-id>`" can be found as the output with key "`KeyPairId`" in the CloudFormation stack that you created using the "`cloudformation/ec2-instance-for-local-build-testing.yaml`" CloudFormation template.
