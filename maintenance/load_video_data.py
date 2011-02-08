#!/usr/bin/python

"""

This program bulk imports the video metadata from the google spreadsheet
(exported to video-data.csv)

 
The best way to init the data is first run
 $ tg-admin sql create
Once you've done that, run
 $ tg-admin shell
 >>> from maintenance import load_video_data
 >>> load_video_data.run()
 >>> [Control-D]
 and when asked if you want to commit the db changes, type 'yes', Enter
"""

from maap.model import *

from datetime import datetime
from time import strptime

import os

import csv

VIDEO_DATA_FILE = './maintenance/video-data.csv'

class VideoData:
    def __init__(self, p):
        """These are the columns"""
        self.place_name = p[0]
        self.video_name = p[1] # this is wrong right now. we are missing this column
        # self.video_name = p[1]
        self.stream_url = p[2]
        self.thumb_url = p[3]
        self.title = p[4]
        self.caption = p[5]
        self.source = p[6]
        self.subject = p[7]
        self.rights = ""
        self.source_url = "http://ccnmtl.columbia.edu"
        # self.thumb_url = p[10]

def run():
    video_data = dict()

    csv_stuff = csv.reader(open(VIDEO_DATA_FILE,'rb'))
    csv_stuff.next() #drop header line

    # Associated place,stream url,title,Caption,Source,Subject/Tags,In point,out point,vocal cue in,vocal cue out,Source URL,notes


    for line in csv_stuff:
        if len(line) < 8:
            print "%s is not yet complete" % line[0]
            continue

        data = VideoData(line)    
        # skip the videos that are not tied to places (general, manually placed - not in the db)
        if not data.place_name == "None":
            video_data[data.video_name] = data

    for video_name in video_data.keys():
        md = video_data[video_name]
        print "Processing %s (%s)" % (video_name, md.place_name)

        place = Place.selectBy(name = md.place_name)

        if place.count() == 0:
            print "Couldn't find %s in the db, skipping." % md.place_name
            continue

        place = place[0]
        # check to see if this video is in our database already
        print "Found %s" % md.place_name
        results = VideoAsset.selectBy(name = md.video_name)

        if results.count() == 0:
            print "Couldn't find the video '%s' in the db, creating a new one" % video_name
            video = VideoAsset(name = md.video_name, 
                               title = md.title,
                               source = '<a href="%s">%s</a>' % (md.source_url, md.source),
                               caption = md.caption,
                               rights = md.rights,
                               subject = md.subject,
                               thumb_url = md.thumb_url,
                               stream_url = md.stream_url
                               )

            place.addVideoAsset(video)
        else: 
            print "Found '%s' in the db, updating metadata" % video_name
            video = results[0]
            video.set(title = md.title,
                      source = '<a href="%s">%s</a>' % (md.source_url, md.source),
                      caption = md.caption,
                      rights = md.rights,
                      subject = md.subject,
                      thumb_url = md.thumb_url,
                      stream_url = md.stream_url
                      )


