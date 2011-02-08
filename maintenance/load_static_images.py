#!/usr/bin/python

"""
This program bulk imports the static images from the filesystem and generates 
thumbnails if one doesn't exist

(maap/static/content/<place name>/images)

<place name> must match an existing place in the database. 

The best way to init the data is first run
 $ tg-admin sql create
Once you've done that, run
 $ tg-admin shell
 >>> import load_static_images
 >>> load_static_images.run()
 >>> [Control-D]
 and when asked if you want to commit the db changes, type 'yes', Enter
"""

from maap.model import *

import os
from os.path import join
import csv
from restclient import POST

# CONTENT_REL_PATH = 'maap/static/content/places'
CONTENT_REL_PATH = '/mnt/cunix/www-data/ccnmtl/projects/maap/content/places'
CONTENT_REL_URL = 'http://maap.columbia.edu/content/places'

DRINKME_URL = 'http://monty.ccnmtl.columbia.edu:8810'

IMAGE_DATA_FILE = './maintenance/image-data.csv'


class ImageData:
    def __init__(self, p):
        """These are the columns"""
        self.place_name = p[0]
        # self.place_title = p[1]
        self.title = p[1]
        self.source_name = p[2]
        self.source_url = p[3]
        self.creator = p[4]
        self.rights = p[5]
        # self.subject = p[6]
        self.caption = p[6]
        self.src_url = p[7]
    
    def getName(self):
        """ full filename, including extension, no path"""
        if self.src_url:
            return self.src_url.split('/')[-1]
        else: 
            return ""


def run():
    image_data = dict()
    csv_stuff = csv.reader(open(IMAGE_DATA_FILE,'rb'))
    csv_stuff.next() #drop header line

    for line in csv_stuff:
        if len(line) < 8:
            print "Uh oh. Short, raggedy line"
            continue

        data = ImageData(line)    
        # only add in metadata if we have it
        if data.src_url:
            # store meta-data in a hash of (full) filename (no path)
            image_data[data.getName()] = data

    #for root, dirs, files in os.walk('maap/static/content'):
    #    for place in dirs:
    #        print place


    dirs = os.listdir(CONTENT_REL_PATH)
    for dir in dirs:
        if not os.path.isdir(join(CONTENT_REL_PATH, dir)):
            continue
        if dir == '.svn':
            continue

        # check to see if this Place is in our database already
        results = Place.selectBy(name = dir)
        if results.count() == 0:
            print "Couldn't find the place '%s' in the database, continuing to next dir" % dir
            continue

        place = results[0]
        print "Processing %s..." % dir

        image_dir = join(CONTENT_REL_PATH, dir, 'images')
        images = os.listdir(image_dir)
        for image in images:
            # ignore everything except for files
            if not os.path.isfile(join(image_dir, image)):
                continue

            # ignore thumbnails
            if image.find('thumb') >= 0:
                continue

            # first, see if this image is already in the database
            src_url = '%s/%s/images/%s' % (CONTENT_REL_URL, dir, image)
            image_base, ext = os.path.splitext(image)
            image_asset = ImageAsset.selectBy(name = image)
            if image_asset.count() > 0:
                print "\t%s: Already exists in the database" % (image)
                if image in image_data:
                    print "updating metadata"
                    i = image_asset[0]

                    # special logic if there is no src url
                    if image_data[image].source_url:
                        source = '<a href="%s">%s</a>' % (image_data[image].source_url, image_data[image].source_name)
                    else:
                        source = image_data[image].source_name


                    i.set(name = image, 
                          title = image_data[image].title,
                          source = source,
                          creator = image_data[image].creator,
                          caption = image_data[image].caption,
                          rights = image_data[image].rights,
                          # subject = image_data[image].subject,
                          base_url = "%s/%s/%s" % (CONTENT_REL_URL, dir, 'images'),
                          )

            else:
                print "\t%s: Couldn't find in the database, adding" % (image)
                # check if there is a thumbnail, otherwise generate one
                if image in image_data:
                    print "\t\t%s: adding meta data" % (image)

                    # special logic if there is no src url
                    if image_data[image].source_url:
                        source = '<a href="%s">%s</a>' % (image_data[image].source_url, image_data[image].source_name)
                    else:
                        source = image_data[image].source_name

                    new_image = ImageAsset(name = image, 
                                           title = image_data[image].title,
                                           source = source,
                                           creator = image_data[image].creator,
                                           caption = image_data[image].caption,
                                           rights = image_data[image].rights,
                                           # subject = image_data[image].subject,
                                           base_url = "%s/%s/%s" % (CONTENT_REL_URL, dir, 'images'),
                                           )
                else: 
                    print "\t\t%s: no meta data found" % (image)
                    new_image = ImageAsset(name = image, 
                                           base_url = "%s/%s/%s" % (CONTENT_REL_URL, dir, 'images'),
                                           )
                place.addImageAsset(new_image)

