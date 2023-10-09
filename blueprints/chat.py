from flask import Flask, render_template, request, redirect, session, jsonify
from flask import Blueprint
import os
from datetime import datetime
from .utils import room_files_path


chat_blueprint = Blueprint('chat', __name__)




# Helper function for deleting users:
def delete_user_msg(room_name,username):
    inputFile = f'{room_files_path}{room_name}.txt'
    with open(inputFile, 'r') as filedata:
        inputFilelines = filedata.readlines()
        with open(inputFile, 'w') as filedata:
            for textline in inputFilelines:
                [hour,msg] = textline.split(']')
                [msg_sender,msg_text] = msg.split(':')
                if msg_sender.split(':')[0] != ' ' + username:
                    filedata.write(textline)
        filedata.close()  

       



# ------------------------- Routes -----------------------------------

@chat_blueprint.route('/lobby', methods=['GET', 'POST'])
def lobby():
    if 'username' in session:
        if request.method == 'POST':
            room_name = request.form['new_room']
            try:
                with open(f'{room_files_path}{room_name}.txt', 'x') as f:
                    f.write('')
            except FileNotFoundError:
                print("The given room name already exists")
            print("CREATED NEW ROOM NAMED: " + room_name )
        rooms = os.listdir(f'{room_files_path}')
        new_rooms = [x[:-4] for x in rooms]
        return render_template('lobby.html', rooms=new_rooms)  
    else:
        return redirect('/login')




@chat_blueprint.route('/chat/<room>', methods=['GET', 'POST'])
def chat(room):
    if 'username' in session:
        return render_template('chat.html', room=room)
    else:
        return redirect('/login')



@chat_blueprint.route('/api/chat/<room>', methods=['GET','POST'])
def update_chat(room):
    if request.method == 'POST':
        username = session['username']

        if request.args.get('clear'):
            delete_user_msg(room,username)
        else:
            message = request.form['msg']
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

            # Append the message to the room's unique .txt file
            with open(f'{room_files_path}{room}.txt', 'a', newline='') as file:
                file.write(f'[{timestamp}] {username}: {message}\n') 
                          
    with open(f'{room_files_path}{room}.txt', 'r' ) as file:
        file.seek(0)
        messages = file.read()
       
    return jsonify([session['username'], messages])
