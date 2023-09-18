# Use a base Python image
FROM python:3.9-slim

# Install the required packages
RUN update-ca-certificates  

# Set the working directory in the container
WORKDIR /app

# Copy all the directory into the container (except of the .dockerignor files)
COPY . .

RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt --no-cache-dir

# Expose the port on which the Flask app will run
EXPOSE 5000

ENV ROOM_FILES_PATH "rooms/"
ENV USERS_PATH "users.csv"
ENV FLASK_ENV development


# Run the Flask app
CMD ["python", "./chatApp.py"]