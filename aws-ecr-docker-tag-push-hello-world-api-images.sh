#!/bin/bash

###############################################################################
## *NOTE: If project does not exist on registry yet, use aws command to
## create it like so:
## aws ecr create-repository --repository-name hello-world-api
###############################################################################

#TODO make it build from build server with tagging and build version.
from_vtag='0.0.1-SNAPSHOT'
to_vtag='0.0.1-SNAPSHOT'

# Be sure to setup your aws configure profile; defaulting aws profile to running username.
aws_profile=$(whoami)
echo "Using AWS profile $aws_profile to tag and push project docker images to ECR"

# AWS account id and region; be sure to set your aws configure set aws_account_id <id> --profile <profile>.
aws_account_id=$(aws configure get aws_account_id --profile $aws_profile)
aws_region_id=$(aws configure get region --profile $aws_profile)

# See AWS ECR Docker Basic: https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-basics.html
#TODO run to authenticate ECR with docker for 12 hours (be sure to do aws config to add your access key befor hand):
#aws ecr get-login --no-include-email
login_token_cmd=$(aws ecr get-login --no-include-email --profile $aws_profile)
eval $login_token_cmd

# Docker tag and push all projects services.
projs=('hello-world-api')

echo
echo "Tag built images as AWS ECR repos.."
echo "Target modules : ${projs[@]}"
echo
for proj in ${projs[@]}; do

   img_from_tag=$proj:$from_vtag
   img_to_tag=$proj:$to_vtag
   echo "Tagging $img_from_tag to $img_to_tag"
   echo

   docker tag $img_from_tag $aws_account_id.dkr.ecr.$aws_region_id.amazonaws.com/$img_to_tag

   docker push $aws_account_id.dkr.ecr.$aws_region_id.amazonaws.com/$img_to_tag

   echo "Done tagging and pushing $img_from_tag to $img_to_tag on AWS ECR ($aws_account_id.dkr.ecr.$aws_region_id.amazonaws.com)"

done
