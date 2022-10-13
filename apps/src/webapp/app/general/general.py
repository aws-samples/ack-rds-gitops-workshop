from flask import Flask, session, Blueprint, render_template, request, jsonify, url_for, redirect
import requests
import json
import os
from .. import models

general_bp = Blueprint("general_bp", __name__ , template_folder="templates/general", static_url_path="/static")
@general_bp.route("/")
def home():
    products = models.Product("fashion")
    response = products.popular_items()
    if response.status_code != 200:
       abort(401)
    popular_items = response.json().get('product_items')
    return render_template("index.html", title="Home", products=popular_items)

@general_bp.route("/apiproduct", methods = ['get'])
def apiproduct():
	r = None
	whereami = None
	content = {"Lab": "DAT312 Workshop"}
	whereami = models.Product().whereami()
	if whereami:
		whereami = whereami.json()
		content["Aurora"] = {"reader": whereami and whereami[0] and whereami[0].get("reader") and whereami[0].get("reader")[0] or None,
			     "writer": whereami and whereami[0] and whereami[0].get("writer") and whereami[0].get("writer")[0] or None}
	try:
		r = requests.get('http://169.254.169.254/latest/dynamic/instance-identity/document', timeout=5)
		if r.status_code == 200:
			content["region"] = r.json().get("region")
			content["instanceId"] = r.json().get("instanceId")
	except:
		pass
	return jsonify(content), 200

@general_bp.route("/healthcheck", methods=['get'])
def healthcheck():
	return {'status': 'success'}, 200

@general_bp.route("/analytic")
def analytics():
        pass
