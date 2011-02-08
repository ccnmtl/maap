#!/usr/bin/python

"""

This program bulk imports a dump of the places table, exported w/ the following command


 % psql -At -F '|' maap -U<username> -c "select * from place" > place.csv


 
The best way to init the data is first run
 $ tg-admin sql create
Once you've done that, run
 $ tg-admin shell
 >>> import load_place_data
 >>> load_place_data.run()
 >>> [Control-D]
 and when asked if you want to commit the db changes, type 'yes', Enter
"""

from maap.model import *

from datetime import datetime
from time import strptime

import os
import csv

# import the monty place data
#PLACE_DATA_FILE = 'places_test.csv'
PLACE_DATA_FILE = './maintenance/place_01022008.csv'

class PlaceData:
    def __init__(self, p):
        """These are the columns"""
        #print p
        # headers
        # (id,name,title,body,now_text,then_text,start_date,end_date,latitude,longitude,featured_image_id,featured_video_id,now_image_id,then_image_id,patch_id) 
        self.name = p[1]
        self.title = p[2]
        self.body = p[3]
        self.now_text = p[4]
        self.then_text = p[5]
        self.start_date = None
        self.end_date = None
        # we are expecting this format - '2007-12-19 18:27:01'
        # use this technique to parse the incoming date strings 
        # http://docs.python.org/lib/node85.html
        if p[6]:       
            self.start_date = datetime(*strptime(p[6], "%Y-%m-%d %H:%M:%S")[0:3])
            # print self.start_date
        if p[7]:
            # print p[7]
            self.end_date = datetime(*strptime(p[7], "%Y-%m-%d %H:%M:%S")[0:3])

        self.lat = float(p[8])
        self.lng = float(p[9])

def run():
    place_data = dict()

    csv.register_dialect('pipes', delimiter='|', quoting=csv.QUOTE_NONE)

    csv_stuff = csv.reader(open(PLACE_DATA_FILE,'rb'), dialect='pipes')
    #csv_stuff.next() #drop header line


    for line in csv_stuff:
        if len(line) < 10:
            print "Skipping %s" % line[1]
            continue

        data = PlaceData(line)
        place_data[data.name] = data

    for place_name in place_data.keys():
        print "Creating %s" % place_name
        new = place_data[place_name]
        # print new.title
        place = Place(name = new.name, 
                      title = new.title, 
                      body = new.body,
                      now_text = new.now_text,
                      then_text= new.then_text,
                      start_date = new.start_date, 
                      end_date = new.end_date,
                      latitude = new.lat,
                      longitude = new.lng,
                      )

# for importing. now, we use this to create.

# for place_name in place_data.keys():
#     print "Updating %s" % place_name
#     new = place_data[place_name]
#     # print new.title
#     old = Place.selectBy(name = place_name)
#     # import pdb; pdb.set_trace()
#     if old.count() > 0:
#         old = list(old)[0]

#         old.set(title = new.title, 
#                 body = new.body,
#                 now_text = new.now_text,
#                 then_text= new.then_text,
#                 start_date = new.start_date, 
#                 end_date = new.end_date,
#                 latitude = new.lat,
#                 longitude = new.lng,
#                 )
#     else: 
#         print "Couldn't find %s in the db" % place_name
            


