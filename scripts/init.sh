# #!/bin/bash

# # Replace with your own values
# INSTANCE_NAME="rivkyschon-first-instance"
# PROJECT_ID="grunitech-mid-project"
# REGION="me-west1"
# ZONE="me-west1-a"
# REPOSITORY="rivkyschon-chat-app-images"
# IMAGE="test"
# #TAG="your-tag"
# gcloud compute ssh efrat-first-instance --project grunitech-mid-project --zone me-west1-a 
# gcloud auth configure-docker me-west1-docker.pkg.dev

# docker pull "me-west1-docker.pkg.dev/grunitech-mid-project/rivkyschon-chat-app-images/test:0.0.0.3"

# gcloud projects add-iam-policy-binding grunitech-mid-project \
#   --member=serviceAccount:my-service-account@grunitech-mid-project.iam.gserviceaccount.com \
#   --role=roles/artifactregistry.reader

# # Prompt the user for the Docker image tag
# read -p "Enter the Docker image tag: " TAG

# # Check if the tag is not empty
# if [ -z "$TAG" ]; then
#     echo "Image tag cannot be empty. Exiting."
#     exit 1
# fi

# # Connect to the Compute Engine instance using SSH
# ssh shifraefrat@34.0.72.214
# gcloud compute ssh $INSTANCE_NAME --project $PROJECT_ID --zone $ZONE << EOF
# # Commands to run on the remote instance

# # Pull the Docker image from Artifact Registry
# docker pull "me-west1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE:$TAG"

# # Run the Docker container from the pulled image
# docker run -d "me-west1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE:$TAG"
# EOF


#!/bin/bash

echo "Enter the version to build and run:"
read version

# Ensure the version input is not empty
if [ -z "$version" ]; then
    echo "Version cannot be empty. Exiting..."
    exit 1
fi

# Check if a container with the given version already exists
if docker ps -a --filter "name=myapp-$version" --format '{{.Names}}' | grep -q "myapp-$version"; then
    echo "A container with version $version already exists."

    # Ask the user whether to delete the container and image
    read -p "Do you want to delete the existing container and image (y/n)? " delete_choice
    if [ "$delete_choice" == "y" ]; then
        # Stop and remove the existing container
        docker stop myapp-$version
        docker rm myapp-$version
        # Remove the existing image
        docker rmi myapp:$version
    else
        echo "Not deleting existing container and image. Exiting..."
        exit 1
    fi
fi

# Your Docker build and run commands using the provided version
docker build -t myapp:$version .
docker run -d --name myapp-$version -p 5000:5000 --cpus "2.0" --memory "1g" -v rooms:/app/rooms myapp:$version
