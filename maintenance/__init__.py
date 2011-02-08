"""
Maintenance command wrappers.

To run one of these, activate your working-env,
do

   % python setup.py develop

(that ensures that the entry points are accessible)

then

   % tg-admin yourcommand

eg,

   % tg-admin load_gmap

This uses the database config in dev.cfg by default. If you need to
use a different one, you'll need to edit the CONFIG_FILE variable.

That will change if we ever figure out how to get "-c config.cfg"
stuff to pass to entry_point commands. 

"""

CONFIG_FILE = "dev.cfg"  # change if you need a different db config

from turbogears import update_config
from turbogears.database import PackageHub

import load_gmap, load_maps, image_thumbs, load_place_data, load_static_images
import load_video_data, make_patches

update_config(configfile=CONFIG_FILE,modulename="maap.config")

hub = PackageHub('maap')

class MaapCommand:
    need_project = True
    def __init__(self,version):
        pass
    def run(self):
        # run it and commit changes to the database
        self._lib.run()
        hub.commit()

class LoadGmap(MaapCommand):
    desc = "loads google map data, i think"
    _lib = load_gmap

class LoadMaps(MaapCommand):
    desc = "loads map data of some sort"
    _lib = load_maps
        
class ImageThumbs(MaapCommand):
    desc = "thumbnails images"
    _lib = image_thumbs

class LoadPlaceData(MaapCommand):
    desc = "loads place data"
    _lib = load_place_data

class LoadStaticImages(MaapCommand):
    desc = "loads static images"
    _lib = load_static_images

class LoadVideoData(MaapCommand):
    desc = "loads video data"
    _lib = load_video_data

class MakePatches(MaapCommand):
    desc = "loads place data"
    _lib = make_patches



        

