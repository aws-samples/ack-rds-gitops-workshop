import os
import json
from rediscluster import RedisCluster
import ast

class Sessionstore:
    """Store session/Kart data in Memcached."""

    def __init__(self, session_id):
        memdbhost = os.environ.get('MEMDB_HOST')
        memdbport = os.environ.get('MEMDB_PORT')
        memdbuser = os.environ.get('MEMDB_USER')
        memdbpass = os.environ.get('MEMDB_PASS')
        redis = RedisCluster(startup_nodes=[{"host": memdbhost, "port": memdbport}],
            decode_responses=True, skip_full_coverage_check=True,
            ssl=True)
        self.redis = redis
        self.sessid = "{}:{}".format('session', session_id)

    def set(self, key, value):
        print (value)
        return self.redis.set(self.sessid + ':' + key, str(value))

    def get(self, key):
        value = self.redis.get(self.sessid + ':' + key)
        if value:
            return ast.literal_eval(value)
        return None

