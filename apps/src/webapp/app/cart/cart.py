from flask import Blueprint, session, render_template, jsonify, request, redirect, url_for
from flask_images import resized_img_src
from app.models import Product, Kart
import json

cart_bp = Blueprint("cart_bp", __name__, template_folder = "templates")

@cart_bp.route("/addToCart")
def addToCart():
    if not session or (session and 'email' not in session):
        return redirect(url_for('auth_bp.main'))
    else:
        productId = int(request.args.get('productId'))
        qty = request.args.get('qty').strip()
        if not qty:
           qty = 1
        qty = int(qty)
        kartSession = Kart(session['email'])
        cartList = kartSession.get('Kart') or []
        found = False
        for x in cartList:
            if x.get('productId') == productId:
                found = True
                x['qty'] = qty
                break
        if not found:
            cartList.append({'productId': productId, 'qty': qty})
        kartSession.set('Kart', cartList)
        #return redirect(url_for('products_bp.view') + "?id={}".format(productId))
        return redirect(url_for('cart_bp.cart'))

@cart_bp.route("/removeFromCart")
def removeFromCart():
    if 'email' not in session:
        return redirect(url_for('auth_bp.home'))
    email = session['email']
    productId = int(request.args.get('productId'))
    kartSession = Kart(email)
    cartList = kartSession.get('Kart') or []
    for x in cartList:
        if x.get('productId') == productId:
            if x['qty'] > 1:
                x['qty'] = x['qty'] - 1
            else:
                # remove array element
                cartList.remove(x)
            break
    kartSession.set('Kart', cartList)
    return redirect(url_for('cart_bp.cart'))

@cart_bp.route("/view")
def main():
	return render_template("cart/view.html")

@cart_bp.route("/cart")
def cart():
    if 'email' not in session:
        return redirect(url_for('auth_bp.main'))
    email = session['email']
    kartSession = Kart(email)
    productsList = kartSession.get('Kart') or []
    if not productsList:
        return redirect(url_for('general_bp.home'))
    productIdList = [ x.get('productId') for x in productsList ]
    response = Product().getProducts(productIdList)
    if response.status_code != 200:
        abort(401)
    products = response.json().get('products')
    for product in products:
       kartval = [ x['qty'] for x in productsList if x['productId'] == product['productid'] ]
       product['qty'] = kartval and kartval[0] or 0
    totalPrice = 0
    noOfItems = 0
    for row in products:
        totalPrice += row.get('price') * row.get('qty')
        noOfItems += 1
    return render_template("cart/cart.html", products = products, totalPrice=round(totalPrice,2), loggedIn=True, firstName=email, noOfItems=noOfItems)

