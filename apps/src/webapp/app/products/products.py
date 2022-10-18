from flask import request, Flask , Blueprint , render_template, jsonify, request, abort ,redirect, url_for
import requests
from app.models import Product
products_bp = Blueprint("products_bp", __name__, template_folder="templates/products")


@products_bp.route("/<product>")
def main(product):
	product_name = product
	product = Product(product)
	response = product.return_items()
	if response.status_code != 200:
		abort(401)
	print (response)
	product_items = response.json().get('product_items')
	page = int(request.args.get("page") or 1)
	if len(product_items) <= 8:
		page = 1
	previous = page - 1
	start = previous * 8
	end = start + 8

	if product_items is None:
		abort(404)
	else:
		print (product_items)
		product_items= [dict(p) for p in product_items]
		print (product_items)
		return render_template("list.html", 
		 products= product_items[start:end],
		 title=product_name , 
		 length=len(product_items))
	
@products_bp.route("/<product>/<product_item>")
def view_product(product, product_item):
	product = Product(product)
	response = product.return_items()
	if response.status_code != 200:
		abort(401)
	product_items = response.json().get('product_items')
	product_items = [dict(p) for p in product_items] 
	product_name = [p for p in product_items if p['name'].lower() == product_item.lower()]
	if len(product_name) == 0:
		abort(404)
	else:
		return render_template("view.html", 
			results={"item":product_name, 
			"keyword":product_item}, 
			title=product_item) 

@products_bp.route("/view")
def view():
	id = int(request.args.get("id"))
	product = Product()
	response = product.product.show_all_items()
	if response.status_code != 200:
		abort(401)
	product_items = response.json().get('product_items')
	product_items = [dict(p) for p in product_items if p['id'] == id]
	return render_template("view.html", 
			results={"item":product_items},
			title="Product View"
			)

@products_bp.route("/whereami")
def whereami():
	return Product().whereami

