from flask import Flask, render_template, request, redirect, session, jsonify
import csv
import os
import base64
from datetime import datetime


app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Set a secret key for session management
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"