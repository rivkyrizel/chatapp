from flask import Blueprint
from flask import Flask, render_template, request, redirect, session, jsonify, flash
import csv
import os
import base64
from datetime import datetime
from .utils import users_path


auth_blueprint = Blueprint('auth', __name__)


# Helper functions for user authentication
def encode_password(password):
    encoded_bytes = base64.b64encode(password.encode('utf-8'))
    return encoded_bytes.decode('utf-8')

 
def decode_password(encoded_password):
    decoded_bytes = base64.b64decode(encoded_password.encode('utf-8'))
    return decoded_bytes.decode('utf-8')



def check_user_credentials(username, password):
    with open(users_path, 'r', newline='', encoding='utf-8') as file:
        reader = csv.reader(file)
        for row in reader:
            try:
                if row[0] == username and decode_password(row[1]) == password:
                    return True
            except UnicodeDecodeError as e:
                print(f"Error decoding data: {e}")
    return False


def user_exists(username):
    with open(users_path, 'r', newline='') as file:
        reader = csv.reader(file)
        for row in reader:
            if row[0] == username:
                return True
    return False


# ------------------------- Routes -----------------------------------


@auth_blueprint.route('/')
def index():
    return redirect('/register')



@auth_blueprint.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        encoded_password = encode_password(password)

        # Check if the user already exists
        if user_exists(username):
            flash("User already exists. Please choose a different username.")
        else:
            # Save user details to the CSV file
            with open(users_path, 'a', newline='') as file:
                writer = csv.writer(file)
                writer.writerow([username, encoded_password])
            return redirect('/login')
            
    return render_template('register.html')




@auth_blueprint.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        if check_user_credentials(username, password):
            session['username'] = username
            return redirect('/lobby')
        else:
            flash('Invalid credentials. Please try again.')
    return render_template('login.html')



@auth_blueprint.route('/logout')
def logout():
    session.pop('username', None)
    return redirect('/login')
