#!/bin/bash

if ! [ $TRAVIS_PULL_REQUEST == "false" ]; then
  echo "This is a pull request. Skipping docker build and ECR deployment.";
  exit 0;
fi

TAG=`if [ "$TRAVIS_BRANCH" == "master" ]; then echo "latest"; else echo $TRAVIS_BRANCH ; fi`
COMMIT=${TRAVIS_COMMIT::8}

aws ecr get-login-password --region "$AWS_DEFAULT_REGION" | docker login -u "$DOCKER_USERNAME" --password-stdin "$IMAGE_REPO_URL"

docker build -t $DOCKER_REPO .

# update and push latest version
docker tag $DOCKER_REPO $IMAGE_REPO_URL/$DOCKER_REPO:$TAG
docker push $IMAGE_REPO_URL/$DOCKER_REPO:$TAG