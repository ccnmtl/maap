#!/usr/bin/python

"""
This program bulk imports the static maps from the filesystem and generates 
thumbnails if one doesn't exist

(maap/static/content/<place name>/images)

<place name> must match an existing place in the database. 

The best way to init the data is first run
 $ tg-admin sql create
Once you've done that, run
 $ tg-admin shell
 >>> import load_maps
 >>> [Control-D]
 and when asked if you want to commit the db changes, type 'yes', Enter
"""

from maap.model import *

import os
from os.path import join
from subprocess import call

from restclient import POST

import datetime

#CONTENT_REL_PATH = 'maap/static/content/maps'
#CONTENT_REL_URL = '/static/content/maps'
CONTENT_REL_PATH = '/mnt/cunix/www-data/ccnmtl/projects/maap/content/maps'
CONTENT_REL_URL = 'http://maap.columbia.edu/content/maps'

DRINKME_URL = 'http://monty.ccnmtl.columbia.edu:8810'

MAP_DATA_FILE = './maintenance/maps-data.csv'

#for root, dirs, files in os.walk('maap/static/content'):
#    for place in dirs:
#        print place

map_data = dict()

import csv

csv_stuff = csv.reader(open(MAP_DATA_FILE,'rb'))
csv_stuff.next() #drop header line
class MData:
    def __init__(self, p):
        """These are the columns"""
        self.title = p[0]
        self.source_name = p[1]
        self.source_url = p[2]
        self.publisher = p[3]
        self.cartographer = p[4]
        self.date = None
        if p[5]:
            self.date = datetime.datetime(int(p[5]),1,1)
        self.scale = p[6]
        self.coverage = p[7]
        self.map_id = p[8]
        self.note = p[9]
        self.resolution = p[10]
        
for line in csv_stuff:
    md = MData(line)
    map_data[md.map_id] = md
    
map_images = os.listdir(CONTENT_REL_PATH)
for image in map_images:
    # ignore everything except for files
    if not os.path.isfile(join(CONTENT_REL_PATH, image)):
            continue

    # ignore thumbnails
    if image.find('thumb') >= 0:
        continue

    # first, see if this image is already in the database
    src_url= '%s/%s' % (CONTENT_REL_URL, image)
    image_base, ext = os.path.splitext(image)

    results = MapAsset.selectBy(name = image_base)

    if results.count() > 0:
        print "\t%s: Already exists in the database, ignoring" % (image)
    else:
        print "\t%s: Couldn't find in the database, adding" % (image)
            # check if there is a thumbnail, otherwise generate one
        
        ## we no longer generate thumbs in this script - instead we use convert on the filesytme
        ##
        #thumb_name = join("thumb","%s_thumb%s" % (image_base, ext))
        ## create a new thumbnail w/ drinkme if one doesn't already exist
        #if not os.path.isfile(join(CONTENT_REL_PATH, thumb_name)):
        #    print "\tCreating a new thumbnail: %s" % thumb_name
        #    image_file = open(join(CONTENT_REL_PATH, image), 'r').read()
        #    thumb_file = open(join(CONTENT_REL_PATH, thumb_name), 'w')
        #    out = POST(DRINKME_URL + '/resize', 
        #                   files= { 'image' : { 'file' : image_file , 'filename' : image }},
        #                   async=False)
        #    thumb_file.write(out)
        #    thumb_file.close()
        #thumb_url = '%s/%s' % (CONTENT_REL_URL, thumb_name)
            
        # add this image into the db
        # print "\tAdding %s (src=%s, thumb=%s)" % (image, src_url, thumb_url)
        if image_base in map_data:
            new_map = MapAsset(name = image_base,
                               title = map_data[image_base].title,
                               publisher = map_data[image_base].publisher,
                               cartographer = map_data[image_base].cartographer,
                               date = map_data[image_base].date,
                               scale = map_data[image_base].scale,
                               coverage = map_data[image_base].coverage,
                               source = '<a href="%s">%s</a>' % (map_data[image_base].source_url ,
                                                                 map_data[image_base].source_name ),

                               base_url = CONTENT_REL_URL,
                               )
        else:
            new_map = MapAsset(name = image_base,
                               base_url = CONTENT_REL_URL,
                               )
    #regardless of it being in the database, go ahead and regenerate the proportions
    #this decision is debatable, since obviously this is a lot of processing
    #but if someone changes the resolution or adds a map, then this should do everything
        
    #if image_base in map_data: # comment this out - we just wnat to manually control the image generation here
    if image_base == '1937sbuhagstrom':
        call(["convert","-resize",
              # map_data[image_base].resolution,
              "100%",
              join(CONTENT_REL_PATH, image),
              join(CONTENT_REL_PATH, 'gigantic' ,image_base) + '_gigantic.jpg'])
        for dim in ['x160','65','100x100','550x550','2000x2000']:
            call(["convert","-resize",
                  dim,
                  join(CONTENT_REL_PATH, image),
                  join(CONTENT_REL_PATH, dim ,image_base) + ('_%s.jpg' % dim) ])
