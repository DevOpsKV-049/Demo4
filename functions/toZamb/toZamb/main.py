from google.cloud import pubsub_v1
import requests
import base64
import json
import os

def message_from_topic2(request, message, data=None):
    project_id = os.environ.get('project')
    subscription_name = "topic2"

    subscriber = pubsub_v1.SubscriberClient()

    subscription_path = subscriber.subscription_path(
        project_id, subscription_name)

    def callback(message):
        # print('Received message: {}'.format(message))
        message.ack()

    subscriber.subscribe(subscription_path, callback=callback)
    if not request:
        return 0
    c = request
    b = base64.b64decode(c['data'])
    d = b.decode('utf-8')
    a = json.loads(d)
    # print(a, type(a))
    link_zamb = os.environ.get('link_zamb')
    requests.post(link_zamb, json=a)