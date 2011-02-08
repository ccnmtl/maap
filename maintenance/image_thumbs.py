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
 >>> import image_thumbs
 >>> image_thumbs.run
 >>> [Control-D]
 and when asked if you want to commit the db changes, type 'yes', Enter
"""

#from maap.model import *

import os
from os.path import join
from subprocess import call
from posix import mkdir


#from restclient import POST

# CONTENT_REL_PATH = 'maap/static/content/places'
CONTENT_REL_PATH = '/mnt/cunix/www-data/ccnmtl/projects/maap/content/places'
CONTENT_REL_URL = 'http://maap.columbia.edu/content/places'

DRINKME_URL = 'http://monty.ccnmtl.columbia.edu:8810'

IMAGE_DATA_FILE = './maintenance/image-data.csv'

# used during maintenance mode, for rebuilding select images
RESIZE_ME = ('eastville',
             )
def run():
    image_data = dict()


    #for root, dirs, files in os.walk('maap/static/content'):
    #    for place in dirs:
    #        print place


    dirs = os.listdir(CONTENT_REL_PATH)
    for dir in dirs:
        if not dir in RESIZE_ME:
            continue
        if not os.path.isdir(join(CONTENT_REL_PATH, dir)):
            continue
        if dir == '.svn':
            continue

        image_dir = join(CONTENT_REL_PATH, dir, 'images')
        images = os.listdir(image_dir)
        for image in images:
            # ignore everything except for files
            file_with_path = join(image_dir, image)
            if not os.path.isfile(file_with_path):
                continue

            # ignore thumbnails
            if image.find('thumb') >= 0:
                continue

            #just jpegs
            if not image.find('.jp') >= 0:
                continue

            image_base, ext = os.path.splitext(image)

            #call(["ls","-lh",file_with_path])
            thumb_dir = join(image_dir, 'thumbs')
            thennow_dir = join(image_dir, '274')
            big_dir = join(image_dir, '820')
            if not os.path.isdir(thumb_dir):
                mkdir(thumb_dir)
            if not os.path.isdir(thennow_dir):
                mkdir(thennow_dir)
            if not os.path.isdir(big_dir):
                mkdir(big_dir)
            print image_base
            call(["convert","-resize","820>",file_with_path, join(big_dir,image_base) + '_820.jpg'])
            call(["convert","-resize","274",file_with_path, join(thennow_dir,image_base) + '_274.jpg'])
            call(["convert","-resize","100x100",file_with_path, join(thumb_dir,image_base) + '_100x100.jpg'])

