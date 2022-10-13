from flask import Flask, abort , session, redirect

from flask_cors import CORS
import logging, sys, json_logging, flask, os
from flask_session import Session
import memcache
from app.products.products import  products_bp
from flask.json import JSONEncoder
import decimal


class JsonEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            return float(obj)
        return JSONEncoder.default(self, obj)

app = Flask(__name__)
json_logging.init_flask(enable_json=True)
json_logging.init_request_instrument(app)
cors = CORS(app)
app.secret_key = os.environ.get('SECRET_KEY', "hhdhdhdhdh7788768")

app.config['SESSION_PERMANENT'] = False
app.config['SESSION_USE_SIGNER'] = True

if os.environ.get('ECHOST'):
    app.config['SESSION_TYPE'] = 'memcached'
    echosts = [ x.split(':')[0] for x in os.environ.get('ECHOST').split(',') ]
    app.config['SESSION_MEMCACHED'] = memcache.Client( echosts )
else:
    app.config['SESSION_TYPE'] = 'filesystem'
    app.config['SESSION_FILE_DIR'] = '/tmp'
    app.config['SESSION_FILE_THRESHOLD'] = 100

Session(app)

app.json_encoder = JsonEncoder

app.register_blueprint(products_bp, url_prefix="/products")

