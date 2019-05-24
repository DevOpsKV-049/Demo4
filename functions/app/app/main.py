from google.cloud import pubsub_v1
import json
import requests
import os
 
def get_data_from_api(request):
    project_id = os.environ.get('project')
    topic_name1 = "topic1"
    topic_name2 = "topic2"
    topic_name3 = "topic3"

    publisher = pubsub_v1.PublisherClient()
    
    topic_path1 = publisher.topic_path(project_id, topic_name1)
    topic_path2 = publisher.topic_path(project_id, topic_name2)
    topic_path3 = publisher.topic_path(project_id, topic_name3)

    list_of_city = [703447, 698740, 702550, 706483, 709930, 707471, 710719, 689558, 703845, 690548]
    apikey = os.environ.get('API')
    
    for i in list_of_city:
        r = requests.get('http://api.openweathermap.org/data/2.5/weather?id={0}&APPID={1}'.format(i, apikey))
        data = json.loads(r.content)
        data_topic1 = json.dumps(data).encode('utf-8')
        data_topic2 = json.dumps({"pressure": data['main']['pressure'], "name": data['name'], "dt": data['dt'], "wind": data['wind']}).encode('utf-8')
        data_topic3 = json.dumps({"temp": data['main']['temp'], "name": data['name'], "dt": data['dt'], "wind": data['wind'], "id": data['id']}).encode('utf-8')
        future1 = publisher.publish(topic_path1, data=data_topic1)
        future2 = publisher.publish(topic_path2, data=data_topic2)
        future3 = publisher.publish(topic_path3, data=data_topic3)
        print("hello")
        print("hello")

