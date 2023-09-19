from flask import Flask, render_template, request, redirect, session, jsonify

# Import your Blueprint modules
from blueprints.auth import auth_blueprint
from blueprints.chat import chat_blueprint

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Set a secret key for session management
# app.config["SESSION_PERMANENT"] = False
# app.config["SESSION_TYPE"] = "filesystem"

# Register the Blueprints with the app
app.register_blueprint(auth_blueprint)
app.register_blueprint(chat_blueprint)


# Error handling
@app.errorhandler(404)
def page_not_found(error):
    return 'Page not found :(', 404


if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)