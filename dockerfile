# # Use a base Python image
# FROM python:3.9-slim

# # Install the required packages
# RUN update-ca-certificates  

# # Set the working directory in the container
# WORKDIR /app

# # Copy all the directory into the container (except of the .dockerignor files)
# COPY . .

# RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt --no-cache-dir


# # Define volumes for saving messages and users
# VOLUME /app/rooms
# # VOLUME /app/users.csv


# # Expose the port on which the Flask app will run
# EXPOSE 5000

# ENV ROOM_FILES_PATH "rooms/"
# ENV USERS_PATH "users.csv"
# ENV FLASK_ENV development


# # Run the Flask app
# CMD ["python", "./chatApp.py"]

# ---------------------   Stage 1: Build The Application -----------------------------
FROM python:3.9-slim AS builder

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends 
RUN rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy only the requirements file to the container
COPY requirements.txt .

# Install the required Python packages into a virtual environment
RUN python -m venv venv && \
    venv/bin/pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org --no-cache-dir -r requirements.txt


#------------------------  Stage 2: Create Smaller Production Image  -------------------------------
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the virtual environment from the builder stage
COPY --from=builder /app/venv venv

# Copy the application code and assets
COPY . .

# Expose the port on which the Flask app will run
EXPOSE 5000

# Define volumes for saving messages and users
# VOLUME /app/users.csv

# Set environment variables
ENV ROOM_FILES_PATH "rooms/"
ENV USERS_PATH "users.csv"
ENV FLASK_ENV development

# Run the Flask app
CMD ["venv/bin/python", "chatApp.py"]
