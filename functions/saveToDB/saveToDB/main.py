from google.cloud import pubsub_v1
from pymongo import MongoClient
import base64
import os

import json


def message_from_topic1(request, message):
    project_id = os.environ.get('project')
    subscription_name = "topic1"

    subscriber = pubsub_v1.SubscriberClient()

    subscription_path = subscriber.subscription_path(
        project_id, subscription_name)

    def callback(message):
        print('Received message: {}'.format(message))
        message.ack()

    subscriber.subscribe(subscription_path, callback=callback)
    # ged DB external IP address

    user_name = os.environ.get('user_name')
    user_pass = os.environ.get('user_pass')
    ip = os.environ.get('ip')

    client = MongoClient('mongodb://{0}:{1}@{2}/mysinoptik'.format(user_name,user_pass,ip), 27017)
    db = client.mysinoptik
    collection_weth = db.weather
    if not request:
        return 0
    c = request
    b = base64.b64decode(c['data'])
    d = b.decode('utf-8')
    a = json.loads(d)

    collection_weth.insert_one(a)

    print('Listening messages {0}, {1}'.format(a, type(a)))











