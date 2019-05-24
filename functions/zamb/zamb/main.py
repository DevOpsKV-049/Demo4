from datetime import datetime
from pymongo import MongoClient
import pymongo
import redis
import json
import os


def result(msg):
    forecast_text = {
        'A': "Settled fine",
        'B': "Fine weather",
        'C': "Becoming fine",
        'D': "Fine, becoming less settled",
        'E': "Fine, possible showers",
        'F': "Fairly fine, improving",
        'G': "Fairly fine, possible showers early",
        'H': "Fairly fine, showery later",
        'I': "Showery early, improving",
        'J': "Changeable, mending",
        'K': "Fairly fine, showers likely",
        'L': "Rather unsettled clearing later",
        'M': "Unsettled, probably improving",
        'N': "Showery, bright intervals",
        'O': "Showery, becoming less settled",
        'P': "Changeable, some rain",
        'Q': "Unsettled, short fine intervals",
        'R': "Unsettled, rain later",
        'S': "Unsettled, some rain",
        'T': "Mostly very unsettled",
        'U': "Occasional rain, worsening",
        'V': "Rain at times, very unsettled",
        'W': "Rain at frequent intervals",
        'X': "Rain, very unsettled",
        'Y': "Stormy, may improve",
        'Z': "Stormy, much rain"
    }
    return forecast_text[msg]


def zamberetti(p):
    z = round(22 * (p - 950) / 100)
    return z


def change_press_wind(pressureGet, windGet):
    if 349.75 <= windGet < 360:
        pressureGet += 6
    elif 0 <= windGet < 12.25:
        pressureGet += 6
    elif 12.25 <= windGet < 34.75:
        pressureGet += 5
    elif 34.75 <= windGet < 57.25:
        pressureGet += 5
    elif 57.25 <= windGet < 79.75:
        pressureGet += 2
    elif 79.5 <= windGet < 102.25:
        pressureGet -= 0.5
    elif 102.25 <= windGet < 124.75:
        pressureGet -= 2
    elif 124.75 <= windGet < 147.25:
        pressureGet -= 5
    elif 147.5 <= windGet < 169.75:
        pressureGet -= 8.5
    elif 169.75 <= windGet < 192.25:
        pressureGet -= 12
    elif 192.25 <= windGet < 214.75:
        pressureGet -= 10
    elif 214.75 <= windGet < 237.25:
        pressureGet -= 6
    elif 237.25 <= windGet < 259.75:
        pressureGet -= 4.5
    elif 259.75 <= windGet < 282.25:
        pressureGet -= 3
    elif 282.25 <= windGet < 304.75:
        pressureGet -= 0.5
    elif 304.75 <= windGet < 327.25:
        pressureGet += 1.5
    elif 327.25 <= windGet < 349.75:
        pressureGet += 3
    return pressureGet

def trend_func(plast, preplast, prepreplast):
    if (plast - preplast >= 4) and (plast - prepreplast >= 4) and (preplast - prepreplast >= 4):
        return 'rise'
    elif (plast - preplast <= -4) and (plast - prepreplast <= -4) and (preplast - prepreplast <= -4):
        return 'fall'
    else:
        return 'stab'

def change_press_month(pressure, trend, month):
    if 3 < month < 9 and trend == 'rise':
        pressure += 7
    elif 3 < month < 9 and trend == 'fall':
        pressure -= 7
    return pressure

def fall_press(zam):
    fallP = ('Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'X', 'X', 'V',
             'U', 'R', 'O', 'H', 'D', 'B', 'B', 'B', 'A', 'A', 'A')
    return fallP[zam]

def rise_press(zam):
    riseP = ('Z', 'Z', 'Z', 'Y', 'Y', 'T', 'Q', 'M', 'L', 'J', 'I',
             'G', 'F', 'C', 'B', 'B', 'A', 'A', 'A', 'A', 'A', 'A')
    return riseP[zam]


def stab_press(zam):
    stabP = ('Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'X', 'X', 'W', 'S', 'P',
             'N', 'K', 'E', 'B', 'B', 'A', 'A', 'A', 'A', 'A', 'A')
    return stabP[zam]

def zamb(request):
    frompubsub = request.get_json()
    # take the city for a key to make a demand in DB
    city = frompubsub['name']
    user_name = os.environ.get('user_name')
    user_pass = os.environ.get('user_pass')
    ip = os.environ.get('ip')
    client = MongoClient('mongodb://{0}:{1}@{2}/mysinoptik'.format(user_name, user_pass, ip), 27017)
    db = client.mysinoptik
    # take 3 last inputs in DB on key "city"
    fromdb = list(db.weather.find({"name": city}, {"wind": 1, "main.pressure": 1, 'dt': 1}).sort('dt', pymongo.DESCENDING).limit(8))
    preplast = fromdb[3]['main']['pressure']
    prepreplast = fromdb[7]['main']['pressure']
    mongo_dt = frompubsub['dt']
    dt = datetime.fromtimestamp(frompubsub['dt'])
    month = dt.month

    try:
        wind = frompubsub['wind']['deg']
        pressure = frompubsub['pressure']
        trend = trend_func(pressure, preplast, prepreplast)
        pressure = change_press_wind(pressure, wind)
        pressure = change_press_month(pressure, trend, month)
        zamber = zamberetti(pressure)
        trendLetter = {'fall': fall_press,'rise': rise_press, 'stab': stab_press}
        forecast = result(trendLetter[trend](zamber))
        print(forecast)
        toredis = json.dumps({'forecast': forecast, 'dt': mongo_dt}).encode('UTF-8')
        ip_redis = os.environ.get('ip_redis')
        redis_pass = os.environ.get('r_pass')
        r = redis.StrictRedis(host=ip_redis, port=13666, db=1, password=redis_pass)
        r.set(city, toredis)

    except:
        ip_redis = os.environ.get('ip_redis')
        redis_pass = os.environ.get('r_pass')
        toredis = json.dumps({'forecast': "There is a lack of information to make a forecast", 'dt': mongo_dt}).encode('UTF-8')
        r = redis.StrictRedis(host=ip_redis, port=13666, db=1, password=redis_pass)
        r.set(city, toredis)

