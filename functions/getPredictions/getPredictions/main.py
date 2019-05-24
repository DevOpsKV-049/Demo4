import requests
import json
import os

def get_predictions(request):
    if not request:
        return 0
    city = request.data.decode("utf-8")
    if city == "test":
        ip_tf = os.environ.get("ip_tf")
        r_to_tf = requests.post('http://{0}:9000'.format(ip_tf), data=json.dumps(city))
    else:
        link_api_to_tf = os.environ.get("link_api_to_tf")
        r_to_api = requests.post(link_api_to_tf, data=city)
        print(r_to_api.content)
        data_from_api = r_to_api.content.decode("utf-8")
        ip_tf = os.environ.get("ip_tf")
        r_to_tf = requests.post('http://{0}:9000'.format(ip_tf), data=data_from_api)
        print(r_to_tf.content)
    return r_to_tf.content
