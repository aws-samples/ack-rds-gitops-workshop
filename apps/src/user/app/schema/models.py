
import os
from rediscluster import RedisCluster

class User:
    def __init__(self):
        memdbhost = os.environ.get('MEMDB_HOST')
        memdbport = os.environ.get('MEMDB_PORT')
        memdbuser = os.environ.get('MEMDB_USER')
        memdbpass = os.environ.get('MEMDB_PASS')
        print ("{} - {}".format(memdbhost, memdbport))
        if memdbuser and memdbpass:
            redis = RedisCluster(startup_nodes=[{"host": memdbhost, "port": memdbport}],
                decode_responses=True, skip_full_coverage_check=True, ssl=True, username=memdbuser, password=memdbpass)
        elif memdbpass:
            redis = RedisCluster(startup_nodes=[{"host": memdbhost, "port": memdbport}],
                decode_responses=True, skip_full_coverage_check=True, ssl=True, password=memdbpass)
        else:
            redis = RedisCluster(startup_nodes=[{"host": memdbhost, "port": memdbport}],
                decode_responses=True, skip_full_coverage_check=True, ssl=True)
        self.redis = redis
        self.user = None
        self.email = None

    def add(self, fname, lname, email, password):
        data = {'fname': fname, 'lname': lname, 'email': email, 'password': password}
        key = 'user:email:{}'.format(email)
        self.redis.hset(key, mapping=data)
        self.user = lname + ", " + fname
        self.email = email
        data['id'] = key
        return data

    def get(self, email):
        key = 'user:email:{}'.format(email)
        data = self.redis.hgetall(key)
        print (data)
        return [ data ]

    def verify(self, email ,password):
        key = 'user:email:{}'.format(email)
        data = self.redis.hgetall(key)
        print ('in verify')
        print (data)
        print (type(data))
        row_count =  len(data)
        if not data:
            return False
        if not data.get('password'):
            return False
        if data.get('password') == password:
            return True
        return False

