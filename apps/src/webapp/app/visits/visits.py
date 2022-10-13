import os, socket
from flask import Blueprint, render_template, request, jsonify, url_for, redirect, Response
from flask import session, redirect, escape, request

visits_bp = Blueprint("visits_bp", __name__, template_folder="templates/visits")

@visits_bp.route('/')
def index():
  username=""
  if session and 'email' in session:
     username = escape(session.get('email'))
  session['visits'] = session.get('visits', 0) + 1
  return u'''<!doctype html>
        <html>
          <head>
             <title>Session Stickyness Test</title>
          </head>
          <body>
           <h1>Session Stickyness Test</h1><br>
           <h2>Logged in as {0} on host <span style="color:red">{1}</span>.</h1>
           <h2>Visits: <span style="color:red">{2}</span></h2>
          </body>
        </html>
        '''.format(username, socket.gethostname(), session.get('visits'))
