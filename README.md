# aws-cicd-test
Example AWS-based CI/CD setup with focus on testing

## Setting up the CI/CD pipeline using AWS CloudFormation

We want to be using automation and Infrastucture as Code (IaC) to set up our CI/CD pipeline.
We have a corresponding AWS CloudFormation template ("`cloudformation/codepipeline-2x-github-codebuild.yaml`") that can be used to create a CloudFormation stack that will create and configure all necessary resources (CodePipeline, CodeBuild, etc.).

### Example

In this example we are setting things up for building the project located in the GitHub repository https://github.com/it-vegard/a11y-reference-website

Example stack name: "pipeline-for-building-and-testing-a11y-reference-website"
Example parameters to use when creating the AWS CloudFormation stack based on the template:

| First Header  | Second Header |
| ------------- | ------------- |
|GitHubRepositoryOwner1|arnesolheim|
|GitHubRepositoryName1|aws-cicd-test|
|GitHubRepositoryOwner2|it-vegard|
|GitHubRepositoryName2|a11y-reference-website|
|PipelineName|build-and-test-a11y-reference-website|
