from flask import Flask, Blueprint, jsonify, request, abort ,redirect, url_for
from app.schema.models import Order
from app.auth.auth import requires_auth
import ast

order_bp = Blueprint("order_bp", __name__)

# @cross_origin(headers=['Content-Type', 'Authorization'])
# @requires_auth

@order_bp.route("/getorder")
def get_order():
    order_id = request.args.get("order_id")
    email = request.args.get("email")
    if not email:
        return jsonify({'title': 'Order Details', 'orders' : {}, 'status_code': 501, 'content': 'missing email'})
    order = Order(email)
    order_details = order.get_orders(order_id)
    return jsonify({'title': 'Order Details', 'orders': order_details, 'status_code': 200})

@order_bp.route("/add", methods=['POST'])
def add_order():
    data = ast.literal_eval(request.data.decode('utf-8'))
    email = data.get('email')
    if not email:
        return jsonify({'title': 'Order Details', 'order_details' : {}, 'status_code': 501, 'content': 'missing email'})
    order = Order(email)
    result = order.add(data)
    data['order_id'] = result
    return jsonify({'title': 'Orders', 'order_details': data, 'status_code': 200})

