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

| First Header  | Second Header |
| ------------- | ------------- |
|GitHubRepositoryOwner1|arnesolheim|
|GitHubRepositoryName1|aws-cicd-test|
|GitHubBranch1|main|
|GitHubRepositoryOwner2|it-vegard|
|GitHubRepositoryName2|a11y-reference-website|
|GitHubBranch2|master|
|PipelineName|build-and-test-a11y-reference-website|
