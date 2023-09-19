from flask import Flask, render_template, request, redirect, session, jsonify
import os

# room_files_path = os.getenv('ROOM_FILES_PATH')
# users_path = os.getenv('USERS_PATH')

room_files_path = "rooms/"
users_path = "users.csv"

