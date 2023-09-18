#!/bin/bash

# Activate your virtual environment (if you're using one)
# source /path/to/your/venv/bin/activate

# Set environment variables if needed
export ROOM_FILES_PATH="rooms/"
export USERS_PATH="users.csv"

# Set the Flask app and environment
export FLASK_APP=app.py  # Replace with the name of your main application file
export FLASK_ENV=development

# Run Flask in debug mode
flask run
