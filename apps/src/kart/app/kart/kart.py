from flask import Flask, Blueprint, jsonify, request, abort ,redirect, url_for
from app.schema.models import Kart
from app.auth.auth import requires_auth
import ast

kart_bp = Blueprint("kart_bp", __name__)

@kart_bp.route("/get")
def get():
    key = request.args.get("key") 
    print ("In Kart, for key value {}".format(key))
    value = Kart().get(key)
    print ("In Kart, extracted for value {} from Model".format(value))
    return jsonify({'key': key, 'value': value})

@kart_bp.route("/set", methods=['POST'])
def set():
    data = ast.literal_eval(request.data.decode('utf-8'))
    key = data.get("key")
    value = data.get("value")
    result = Kart().set(key, value)
    print (result)
    return jsonify({'key': key, 'value': value})

@kart_bp.route("/remove",  methods=['POST'])
def remove():
    data = ast.literal_eval(request.data.decode('utf-8'))
    key = data.get("key")
    result = Kart().delete(key)
    return jsonify({'key': key, value: None})
