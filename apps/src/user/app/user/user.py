from flask import Flask, Blueprint, jsonify, request, abort ,redirect, url_for
from app.schema.models import User
from app.auth.auth import requires_auth
import json
import ast

user_bp = Blueprint("user_bp", __name__)

# @cross_origin(headers=['Content-Type', 'Authorization'])
# @requires_auth

@user_bp.route("/add", methods=['POST'])
def add_user():
    data = ast.literal_eval(request.data.decode('utf-8'))
    user = User()
    user.add(data.get('fname'), data.get('lname'), data.get('email'), data.get('password'))
    return jsonify({'title': 'User', 'result': True})

@user_bp.route("/getuser", methods=['GET'])
def get_user():
    email = request.args.get('email')
    user = User()
    userinfo = user.get(email)
    return jsonify({'title': 'User Info', 'result': userinfo})

@user_bp.route("/verify", methods=['GET'])
def verify_user():
    email = request.args.get('email')
    password = request.args.get('password')
    user = User()
    result = user.verify(email, password)
    return jsonify({'title': 'User Check', 'result': result})
