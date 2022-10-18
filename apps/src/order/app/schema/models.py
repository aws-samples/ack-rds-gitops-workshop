import psycopg2
from psycopg2.extras import RealDictCursor
import os


def connect():
    rds_host = os.environ['DATABASE_HOST']
    db_user = os.environ['DATABASE_USER']
    password = os.environ['DATABASE_PASSWORD']
    db_name = os.environ['DATABASE_DB_NAME']
    port = os.environ['DATABASE_PORT']

    return psycopg2.connect(sslmode="require", host=rds_host, user=db_user, password=password, dbname=db_name, connect_timeout=10000, port=port, keepalives_interval=30)

class Order:
    def __init__(self, email):
        self.email = email

    def get_orders(self, order_id=None):
        with connect() as dbconn:
            with dbconn.cursor(cursor_factory=RealDictCursor) as cur:
                sqlstmt = "select d.item_id, d.qty, d.unit_price, o.order_date from order_details d join orders o on o.order_id = d.order_id and o.email = '{}'".format(self.email)
                if order_id:
                    sqlstmt = "{} where o.order_id = {}".format(sqlstmt, order_id)
                print (sqlstmt)
                cur.execute(sqlstmt)
                return cur.fetchall()
    
    def add(self, data):
        with connect() as dbconn:
            with dbconn.cursor(cursor_factory=RealDictCursor) as cur:
                sqlstmt = "select nextval('order_seq');"
                cur.execute(sqlstmt)
                order_id = cur.fetchone()['nextval']
                items = data.get('items')
                total = 0
                for x in items:
                    sqlstmt = 'insert into order_details(order_id, item_id, qty, unit_price) values({}, {}, {}, {});'.format(order_id, x.get('item_id'), x.get('qty'), x.get('unit_price'))
                    cur.execute(sqlstmt)
                    total += (x.get('qty') * x.get('unit_price'))
                sqlstmt = "insert into orders(order_id, order_date, order_total, email) values({}, now(), {}, '{}')".format(order_id, total, self.email)
                cur.execute(sqlstmt)
                dbconn.commit()
                return order_id
