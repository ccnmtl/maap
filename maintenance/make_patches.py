#!/usr/bin/python

"""

This program bulk imports a dump of the places table, exported w/ the following command


 % psql -At -F '|' maap -U<username> -c "select * from place" > place.csv


 
The best way to init the data is first run
 $ tg-admin sql create
Once you've done that, run
 $ tg-admin shell
 >>> import make_patches
 >>> make_patches.run()
 >>> [Control-D]
 and when asked if you want to commit the db changes, type 'yes', Enter
"""

from maap.model import *

from datetime import datetime
from time import strptime
from subprocess import call

import os
from os.path import join

import re

CONTENT_REL_PATH = '/mnt/cunix/www-data/ccnmtl/projects/maap/content/maps'

def run():
    from PIL import Image
    for p in Place.select():
        if p.patch and p.patch.src_url:
            r = re.match('z=([.\d]*)&cx=([.\d]*)&cy=([.\d]*)',p.patch.src_url)
            z = float(r.group(1))
            cx = float(r.group(2))
            cy = float(r.group(3))

            maap = p.patch.parent_map
            imgname = maap.name

            #assume gigantic image
            imglocation = join(CONTENT_REL_PATH,'gigantic',imgname+'_gigantic.jpg')

            output_path = join(CONTENT_REL_PATH, 'crop','patch_%d.jpg' %p.patch.id)
            output_path2 = join(CONTENT_REL_PATH, 'crop','patch_%d_207x207.jpg' %p.patch.id)

            if not os.path.isfile(imglocation):
                continue

            ## ONLY CREATE NEW PATCHES, don't update existing ones
            ## during maintenance mode, we don't want to regenerate patches
            ## only create new ones
            ##  - jsb
            if os.path.isfile(output_path):  
                continue

            pil_image = Image.open(imglocation)
            nil,nil,w,h = pil_image.getbbox()

            o_dimension = 550
            bbox = 207

            #import pdb
            #pdb.set_trace()

            if w>h:
                ow=o_dimension
                oh=o_dimension*h/w
            else:
                oh=o_dimension
                ow=o_dimension*w/h

            side = w*bbox/(z*ow)

            dx = w*cx - side/2
            dy = h*cy - side/2

            #make the crop
            call(['convert','-crop',
                  '%dx%d+%d+%d' % (side,side,dx,dy),
                  imglocation,
                  output_path,
                  ])
            #resize it
            call(['convert','-resize',
                  '207x207',
                  output_path,
                  output_path2,
                  ])
