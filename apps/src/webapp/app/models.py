import requests, sys, json, os
from functools import wraps
import time

_CONNECT_FAILURE_MAX_RETRIES = 3   # 500 errors retries
_CONNECT_FAILURE_BACKOFF = 0.5     # 500 errors retry backoff factor
_CONNECT_TIMEOUT = 3  # connect timeout
_READ_TIMEOUT = 300  # read timeout

class ModelsApiException(Exception):
    """exceptions raised by PatroniApi class"""
    def __init__(self, message, errors=None):
        if errors is not None:
            super(ModelsApiException, self).__init__(message + (': "{0!r}"'.format(errors)))
            self.errors = errors
        else:
            super(ModelsApiException, self).__init__(message)


class ModelsApi(object):
  def __init__(self, api_url=None):
    self._session = requests.Session()
    self.api_url = api_url

  def _retry(exc_to_check, tries=_CONNECT_FAILURE_MAX_RETRIES, delay=3, backoff=1):
    def deco_retry(func):
        @wraps(func)
        def f_retry(*args, **kwargs):
            mtries, mdelay = tries, delay
            while mtries > 1:
                try:
                    return func(*args, **kwargs)
                except exc_to_check:
                    time.sleep(mdelay)
                    mtries -= 1
                    mdelay *= backoff
            return func(*args, **kwargs)
        return f_retry  # true decorator
    return deco_retry

  @_retry((ModelsApiException, requests.exceptions.ConnectionError), tries=3, delay=30)
  def _get(self, urlpath, **kwargs):
      """ requsts get
      """
      print ('Calling API, {}/{}'.format(self.api_url, urlpath))
      response = self._session.get("{}/{}".format(self.api_url, urlpath), timeout=(_CONNECT_TIMEOUT, _READ_TIMEOUT), **kwargs)
      print (response)
      self._raise_on_error(response, sys._getframe().f_code.co_name)
      return response

  @_retry((ModelsApiException, requests.exceptions.ConnectionError), tries=3, delay=30)
  def _post(self, urlpath, data, **kwargs):
      """ requsts get
      """
      print ('Calling API, {}/{}'.format(self.api_url, urlpath))
      response = self._session.post("{}/{}".format(self.api_url, urlpath), data=json.dumps(data), timeout=(_CONNECT_TIMEOUT, _READ_TIMEOUT), **kwargs)
      print (response)
      self._raise_on_error(response, sys._getframe().f_code.co_name)
      return response

  def __enter__(self):
      return self

  def __exit__(self, exc_type, exc_value, traceback):
      try:
        self._session.close()
      except:
        pass

  def _raise_on_error(self, response, func_passed):
      """parse requests error if any"""
      if not 200 <= response.status_code <= 299:
          err_message = ''
          if response.text:
              try:
                  err_dict = json.loads(response.text)
                  err_message = self._parse_dict(err_dict)
              except ValueError:
                  err_message = response.text
          raise ModelsApiException('HTTP {0}: "{1}"\n{2}'.format(response.status_code, err_message, response.url), errors=response)

  def _parse_dict(self, d):
      """helper function for parsing requests error"""
      for k, v in d.items():
            if isinstance(v, dict):
                return '{0}: {1}'.format(k, self._parse_dict(v))
            else:
                return '{0}: {1}'.format(k, v)

class Product:
    def __init__(self, product_name=None):
        self.products_service = ModelsApi(os.environ.get('PRODUCTS_SERVICE') + "/products")
        self.product_name = product_name

    def whereami(self):
        return self.products_service._get('whereami')

    def return_items(self):
        return self.products_service._get(self.product_name)

    def popular_items(self, top=5):
        return self.products_service._get('popularitems?top={}'.format(top))

    def show_all_items(self):
        return self.products_service._get('view')

    def getProducts(self, productListString):
        print (type(productListString))
        print (productListString)
        if isinstance(productListString, list):
            productListString = ','.join([str(x) for x in productListString])
        print (type(productListString))
        print (productListString)
        return self.products_service._get('getproducts?productlist={}'.format(productListString))

class User:
    def __init__(self):
        self.user_service = ModelsApi(os.environ.get('USER_SERVICE') + "/user")
        self.user = None
        self.email = None

    def add(self, fname, lname, email, password):
        payload = {'fname': fname, 'lname': lname, 'email': email, 'password': password}
        response = self.user_service._post("add", payload)
        self.user = lname + ", " + fname
        self.email = email
        return response

    def get(self, email):
        response = self.user_service._get("getuser?email={}".format(email))
        if response.status_code != 200:
            abort(401)
        return response.json().get('result')

    def verify(self, email ,password):
        response = self.user_service._get("verify?email={}&password={}".format(email, password))
        if response.status_code != 200:
            return False
        return response.json().get('result')

class Kart:
    def __init__(self, email):
        self.kart_service = ModelsApi(os.environ.get('KART_SERVICE') + "/kart")
        self.email = email

    def get(self, key):
        print (key)
        key = "{}:{}".format(self.email, key)
        response = self.kart_service._get('get?key={}'.format(key))
        return response.json().get('value')

    def set(self, key, value):
        print (key)
        print (value)
        print (type(value))
        key = "{}:{}".format(self.email, key)
        payload = {"key": key, "value": value}
        response = self.kart_service._post("set", payload)
        return response.json().get('value')

class Review:
    def __init__(self):
        pass

    def __repr__(self):
        pass
