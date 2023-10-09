#!/bin/bash

# Function to build or rebuild the Docker image
build_docker_image() {
  docker build -t my-chatapp:${version} .
  echo "Docker image for version ${version} has been built."
}

# Function to push the Docker image to Artifact Registry
push_to_artifact_registry() {
  gcloud config set auth/impersonate_service_account artifact-admin-sa@grunitech-mid-project.iam.gserviceaccount.com
  gcloud auth configure-docker me-west1-docker.pkg.dev

  docker tag my-chatapp:${version} me-west1-docker.pkg.dev/grunitech-mid-project/efrat-chat-app-images/test:${version}
  docker push me-west1-docker.pkg.dev/grunitech-mid-project/efrat-chat-app-images/test:${version}

  echo "The Docker image has been pushed to the Artifact Registry."
  gcloud config unset auth/impersonate_service_account
  gcloud auth login
}

# Check if the user has provided a version
if [ -z "$1" ]; then
  echo "Usage: deploy.sh <version>"
  exit 1
fi

# Get the version from the user
version=$1

# Check if the Docker image exists
if docker image inspect my-chatapp:${version} >/dev/null 2>&1; then
  echo "The Docker image for version ${version} already exists."
  echo "Do you want to rebuild the image (y/n)?"
  read -n 1 rebuild_image

  if [ "$rebuild_image" == "y" ]; then
    docker rmi my-chatapp:${version} && echo "Deleted the existing Docker image for version ${version}."
    build_docker_image
  else
    echo "Using the existing Docker image for version ${version}."
  fi
else
  build_docker_image
fi

# Ask the user if they want to push the image to Artifact Registry
echo "Do you want to push the Docker image to Artifact Registry (y/n)?"
read -n 1 push_to_registry

if [ "$push_to_registry" == "y" ]; then
  push_to_artifact_registry
else
  echo "Pushing the Docker image to the Artifact Registry has been skipped."
fi

echo "Done!"
