#!/bin/bash

getOwnAccountId () {
    # https://docs.aws.amazon.com/cli/latest/reference/sts/get-caller-identity.html
    local awsProfileName=$1
    local awsProfileParam=""
    if [ "${awsProfileName}" != "NO_PROFILE" ]; then
        awsProfileParam="--profile ${awsProfileName}"
    fi
    aws ${awsProfileParam} sts get-caller-identity --query "Account" --output text
}

if [ $# -ne 5 ]
  then
    echo "Usage: $0 <aws_profile_name|NO_PROFILE> <image_name> <image_tag> <repository_name> <region>"
    exit
fi

export aws_profile_name=${1}
export image_name=${2}
export image_tag=${3}
export repository_name=${4}
export aws_region=${5}
export accountId=$(getOwnAccountId ${aws_profile_name})
export docker_server=${accountId}.dkr.ecr.${aws_region}.amazonaws.com

export aws_profile_param=""
if [ "${aws_profile_name}" != "NO_PROFILE" ]; then
    export aws_profile_param="--profile ${aws_profile_name}"
fi

# See https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html
echo "Script name:           [$0]"
echo "AWS CLI version:       [$(aws --version)]"
echo "AWS Account ID:        [${accountId}]"
echo "AWS profile reference: [${aws_profile_name}]"
echo "Logging in to server:  [${docker_server}]"
# See https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecr/get-login-password.html
aws ${aws_profile_param} --region ${aws_region} ecr get-login-password \
| docker login --username AWS --password-stdin ${docker_server}

# See https://docs.docker.com/engine/reference/commandline/tag/
echo "[$0] Tagging image [${image_name}] with tag [${image_tag}] in the remote repository"
docker image tag ${image_name}:${image_tag} ${docker_server}/${repository_name}:${image_tag}

if [ ! -z "${GIT_COMMIT_ID}" ]; then
    echo "[$0] Tagging image [${image_name}] with tag [${GIT_COMMIT_ID}] in the remote repository"
    docker image tag ${image_name}:${image_tag} ${docker_server}/${repository_name}:${GIT_COMMIT_ID}
fi

# See https://docs.docker.com/engine/reference/commandline/push/
echo "[$0] pushing the image to [${docker_server}] (repository name: [${repository_name}])"
docker image push --all-tags ${docker_server}/${repository_name}
