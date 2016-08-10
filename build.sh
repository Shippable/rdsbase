#!/bin/bash -e

export BRANCH=master
export IMAGE_NAME=shipimg/rdsbase
export IMAGE_TAG=$BRANCH.$BUILD_NUMBER
export RES_DOCKER_CREDS=docker-creds
export RES_RDS_REPO=rdsbase-repo
export RES_RDS_IMAGE=rdsbase-img

dockerBuild() {
  echo "Starting Docker build for" $IMAGE_NAME:$IMAGE_TAG
  cd ./IN/$RES_RDS_REPO/gitRepo
  sudo docker build -t=$IMAGE_NAME:$IMAGE_TAG .
  echo "Completed Docker build for" $IMAGE_NAME:$IMAGE_TAG
}

dockerPush() {
  echo "Starting Docker push for" $IMAGE_NAME:$IMAGE_TAG
  sudo docker push $IMAGE_NAME:$IMAGE_TAG
  echo "Completed Docker push for" $IMAGE_NAME:$IMAGE_TAG
}

dockerLogin() {
  echo "Extracting docker creds"
  . ./IN/$RES_DOCKER_CREDS/integration.env
  echo "logging into Docker with username" $username
  docker login -u $username -p $password
  echo "Completed Docker login"
}

createOutState() {
  echo "Creating a state file for" $RES_RDS_IMAGE
  echo versionName=$IMAGE_TAG > /build/state/$RES_RDS_IMAGE.env
  cat /build/state/$RES_RDS_IMAGE.env
  echo "Completed creating a state file for" $RES_RDS_IMAGE
}

main() {
  dockerLogin
  dockerBuild
  dockerPush
  createOutState
}

main
