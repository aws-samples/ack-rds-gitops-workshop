import psycopg2
from psycopg2.extras import RealDictCursor
import os


def connect(role="writer"):
    rds_host = os.environ['DATABASE_HOST']
    db_user = os.environ['DATABASE_USER']
    password = os.environ['DATABASE_PASSWORD']
    db_name = os.environ['DATABASE_DB_NAME']
    port = os.environ['DATABASE_PORT']

    return psycopg2.connect(sslmode="require", host=rds_host, user=db_user, password=password, dbname=db_name, connect_timeout=10000, port=port, keepalives_interval=30)

class Product:
    def __init__(self, product_name=None):
        self.product_name = product_name
        self.db = connect()

    def fetch_data_new(self, sqlstmt):
        try:
            with self.db.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute(sqlstmt)
                return cur.fetchall()
        except Exception:
            with self.db.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute(sqlstmt)
                return cur.fetchall()

    def fetch_data(self, dbconn, sqlstmt):
        try:
            with dbconn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute(sqlstmt)
                return cur.fetchall()
        except Exception:
            with connect() as dbconn:
                with dbconn.cursor(cursor_factory=RealDictCursor) as cur:
                    cur.execute(sqlstmt)
                    return cur.fetchall()
    
    def return_items(self):
        with connect() as dbconn:
            sqlstmt = "SELECT * FROM {}".format(self.product_name)
            return self.fetch_data(dbconn, sqlstmt)

    def popular_items(self, top=5, interval=180):
        with connect() as dbconn:
            sqlstmt = """
                      with items as (
                      select item_id
                      from (
                       select item_id, cnt, 
                              rank() over (order by cnt desc) mrank
                       from (
                        select item_id, count(1) as cnt
                        from orders a join order_details b 
                         on a.order_id = b.order_id 
                        group by item_id
                        ) t
                       ) t where mrank <= {0} order by cnt desc
                      )
                      SELECT id,name,price, description,img_url,'apparels' as category, count(1) review_cnt, round(avg(rating)*20) rating
                      FROM apparels a join items i on i.item_id = a.id 
                       left outer join reviews r on r.category='apparels' and i.item_id = r.item_id
                      GROUP BY id,name,price, description,img_url
                      UNION
                      SELECT id,name,price, description,img_url,'fashion' as category, count(1) review_cnt, round(avg(rating)*20) rating
                      FROM fashion a join items i on i.item_id = a.id 
                       left outer join reviews r on r.category='fashion' and i.item_id = r.item_id
                      GROUP BY id,name,price, description,img_url
                      UNION
                      SELECT id,name, price, description,img_url,'bicycles' as category, count(1) review_cnt, round(avg(rating)*20) rating
                      FROM bicycles a join items i on i.item_id = a.id 
                       left outer join reviews r on r.category='bicycles' and i.item_id = r.item_id
                      GROUP BY id,name,price, description,img_url
                      UNION
                      SELECT id,name, price, description,img_url,'jewelry' as category, count(1) review_cnt, round(avg(rating)*20) rating
                       FROM jewelry a join items i on i.item_id = a.id 
                       left outer join reviews r on r.category='jewelry' and i.item_id = r.item_id
                      GROUP BY id,name,price, description,img_url
                       """.format(top)
            return self.fetch_data(dbconn, sqlstmt)

    def show_all_items(self, id=None):
        with connect() as dbconn:
            if id:
                sqlstmt = """
                SELECT id,name,price, description,img_url FROM apparels where id = {0}
                UNION
                SELECT id,name,price, description,img_url FROM fashion where id = {0}
                UNION
                SELECT id,name, price, description,img_url FROM bicycles where id = {0}
                UNION 
                SELECT id,name, price, description,img_url FROM jewelry where id = {0}
                ORDER BY name
                """.format(id)
            else:
                sqlstmt = """
                SELECT id,name,price, description,img_url FROM apparels
                UNION
                SELECT id,name,price, description,img_url FROM fashion
                UNION
                SELECT id,name, price, description,img_url FROM bicycles
                UNION 
                SELECT id,name, price, description,img_url FROM jewelry
                ORDER BY name
                """
            return self.fetch_data(dbconn, sqlstmt)

    def show_all_items_new(self, id=None):
        if id:
            sqlstmt = """
            SELECT id,name,price, description,img_url FROM apparels where id = {0}
            UNION
            SELECT id,name,price, description,img_url FROM fashion where id = {0}
            UNION
            SELECT id,name, price, description,img_url FROM bicycles where id = {0}
            UNION 
            SELECT id,name, price, description,img_url FROM jewelry where id = {0}
            ORDER BY name
            """.format(id)
        else:
            sqlstmt = """
            SELECT id,name,price, description,img_url FROM apparels
            UNION
            SELECT id,name,price, description,img_url FROM fashion
            UNION
            SELECT id,name, price, description,img_url FROM bicycles
            UNION 
            SELECT id,name, price, description,img_url FROM jewelry
            ORDER BY name
            """
        return self.fetch_data_new(sqlstmt)

    def getProducts(self, productListString):
        if isinstance(productListString, str):
            productListString=[productListString]
        elif isinstance(productListString, int):
            productListString=[productListString]
        print (productListString)
        if isinstance(productListString, list):
            productListString = ",".join(productListString)
            sqlstmt = """select id as productId, name, price, img_url from apparels a where id in ({0})
                         union
                         select id as productId, name, price, img_url from fashion a where id in ({0})
                         union
                         select id as productId, name, price, img_url from bicycles a where id in ({0})
                         union
                         select id as productId, name, price, img_url from jewelry a where id in ({0})
                      """.format(productListString)
            with connect("reader") as dbconn:
                return self.fetch_data(dbconn, sqlstmt)

    def whereami(self):
        sqlstmt = "select inet_server_addr();"
        with connect("writer") as dbconn:
            writer = self.fetch_data(dbconn, sqlstmt, "writer")
            with connect("reader") as dbconn:
                reader = self.fetch_data(dbconn, sqlstmt, "writer")
                return [{"writer": writer, "reader": reader}]

    def addProduct(self, category, product):
        if not isinstance(product, list):
            product = ast.literal_eval(product)
            sqlstmt = """insert into {0} (name, description, img_url, category, inventory, price)
                         values ({1}, {2}, {3}, {4}, {6}) returning *;""".format(category, product.get(name), product.get(description), product.get(img_url), product.get(category), product.get(inventory), product.get(price))
            with connect("writer") as dbconn:
                return self.fetch_data(dbconn, sqlstmt, "writer")


