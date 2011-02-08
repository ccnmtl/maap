#!/usr/bin/python
# -*- coding: utf-8 -*-

from maap.model import *
#The best way to init the data is first run
# $ tg-admin sql create
#Once you've done that, run
# $ tg-admin shell
# >>> import load_gmap
# >>> load_gmap.run()
# >>> [Control-D]
# and when asked if you want to commit the db changes, type 'yes', Enter

from xml.dom import minidom


def run():
    gmap_kml = minidom.parse("./maintenance/MAAP_locations_google.kml")

    for node in gmap_kml.getElementsByTagName('Placemark'):
        title = node.getElementsByTagName('name')[0].firstChild.data.encode('utf8')
        name = title.lower().replace(' ', '_').replace("'", "-").replace("’", "-").replace(".", "")

        # do a db lookup. If place already exists, continue
        place = Place.selectBy(name=name)
        if place.count() > 0:
            print "\t%s: Already exists in the database, ignoring." % name
            continue

        description = node.getElementsByTagName('description')[0].firstChild.data.encode('utf8')
        coordinates = node.getElementsByTagName('coordinates')[0].firstChild.data.encode('utf8')
        # these come in as lng, lat, z, 
        (x,y,z) = coordinates.split(",")
        new_place = Place(name=name,
                          title=title,
                          body=description,
                          latitude=float(y),
                          longitude=float(x))

        print "Added: %s" % (name)
    
