from datetime import date
from datetime import timedelta
import json
from collections import namedtuple
import requests


def data_to_predict(request):
    city = request.data
    print(city.decode("utf-8"))
    URL = "http://api.worldweatheronline.com/premium/v1/past-weather.ashx?" \
          "key=a63fac0e330045a5af9150941193003&q={2}&date={0}&enddate={1}&tp=1&format=json"

    list_of_city = {"Kyiv": "Kiev, Ukraine",
                    "Lviv": "Lviv, Ukraine",
                    "Kharkiv": "Kharkiv, Ukraine",
                    "Uzhhorod": "Uzhhorod, Ukraine",
                    "Chernivtsi": "Chernivtsi, Ukraine",
                    "Dnipro": "Dnipropetrovsk, Ukraine",
                    "Vinnytsia": "Vinnytsya, Ukraine",
                    "Kriviy Rih": "Kryvyy Rih, Ukraine",
                    "Odessa": "Odessa, Ukraine",
                    "Ivano-Frankivsk": "Kalush, Ukraine"}


    start_date = str(date.today() - timedelta(days=2))
    end_date = str(date.today() + timedelta(days=1))
    city = request.data

    r2 = requests.get(URL.format(start_date, end_date, list_of_city[city.decode("utf-8")]))

    records = {}

    features = ["date", "meantempm", "meandewptm", "meanpressurem", "maxhumidity", "minhumidity", "maxtempm",
                "mintempm", "maxdewptm", "mindewptm", "maxpressurem", "minpressurem", "precipm"]

    DailySummary = namedtuple("DailySummary", features)

    record = []

    raw_data = json.loads(r2.content)

    for w in raw_data["data"]["weather"]:
        meantempm1 = 0
        meandewptm1 = 0
        meanpressurem1 = 0
        maxhumidity1 = 0
        minhumidity1 = 100
        maxtempm1 = -200
        mintempm1 = 200
        maxdewptm1 = -200
        mindewptm1 = 200
        maxpressurem1 = 0
        minpressurem1 = 2000
        precipm1 = 0

        for h in w["hourly"]:

            meantempm1 += float(h["tempC"])
            meandewptm1 += float(h["DewPointC"])
            meanpressurem1 += float(h["pressure"])

            if float(h["humidity"]) > maxhumidity1:
                maxhumidity1 = float(h["humidity"])
            if float(h["humidity"]) < maxhumidity1:
                minhumidity1 = float(h["humidity"])
            if maxtempm1 < float(h["tempC"]):
                maxtempm1 = float(h["tempC"])
            if mintempm1 > float(h["tempC"]):
                mintempm1 = float(h["tempC"])
            if maxdewptm1 < float(h["DewPointC"]):
                maxdewptm1 = float(h["DewPointC"])
            if mindewptm1 > float(h["DewPointC"]):
                mindewptm1 = float(h["DewPointC"])
            if maxpressurem1 < float(h["pressure"]):
                maxpressurem1 = float(h["pressure"])
            if minpressurem1 > float(h["pressure"]):
                minpressurem1 = float(h["pressure"])
            precipm1 = float(h["precipMM"])

        record.append(DailySummary(date=w["date"],
                                   meantempm=meantempm1/24,
                                   meandewptm=meandewptm1/24,
                                   meanpressurem=meanpressurem1/24,
                                   maxhumidity=maxhumidity1,
                                   minhumidity=minhumidity1,
                                   maxtempm=maxtempm1,
                                   mintempm=mintempm1,
                                   maxdewptm=maxdewptm1,
                                   mindewptm=mindewptm1,
                                   maxpressurem=maxpressurem1,
                                   minpressurem=minpressurem1,
                                   precipm=precipm1))

    records[city.decode("utf-8")] = record

    return json.dumps(records)