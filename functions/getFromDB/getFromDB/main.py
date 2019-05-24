# FUNC
import pymongo
import json
import datetime
import time
import re
import os

def get_from_db(request):
#prepare for fetching from mongodb
    user_name = os.environ.get('user_name')
    user_pass = os.environ.get('user_pass')
    ip = os.environ.get('ip')

    client = pymongo.MongoClient('mongodb://{0}:{1}@{2}/mysinoptik'.format(user_name,user_pass,ip), 27017)
    db = client.mysinoptik
    coll = db.weather
    if not request:
        return 0
#convert JSON request into dict
    arg = json.loads(request.data)
#convert time string from UI in UNIX time
    time_min_conv = datetime.datetime.strptime(arg["time_min"], '%Y-%m-%d %X')
    time_min_unix = time.mktime(time_min_conv.timetuple())
    time_max_conv = datetime.datetime.strptime(arg["time_max"], '%Y-%m-%d %X')
    time_max_unix = time.mktime(time_max_conv.timetuple())
#gets data and time from mongodb
    raw_array = list(coll.find({'id': arg['id'], "$and": [{"dt": {"$gte": time_min_unix}}, {"dt": {"$lte": time_max_unix}}]},
            {"_id": 0, arg['data']:1, 'dt': 1}))
#beatify data from mongodb into 2 arrays

    beautiful_arr = [[], []]

    regex_pattern = re.compile(r'(.*)\.(.*)')#parses string like 'sys.sunrise' into 'sys' and 'sunrise' strings
    rg = regex_pattern.search(arg['data'])

    for i in raw_array:
        beautiful_arr[0].append(i['dt'])
        beautiful_arr[1].append(i[rg.group(1)][rg.group(2)])

    return json.dumps(beautiful_arr)
