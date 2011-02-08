from datetime import datetime
from turbogears.database import PackageHub
from sqlobject import *
from turbogears import identity

hub = PackageHub('maap')
__connection__ = hub

soClasses = ["Place", "Module", "Lesson", "MapAsset", "MapPatch", "ImageAsset", "VideoAsset"]

# create century constants for date arithemetic
# (to compute color of place icons)
CENTURIES = { 'seventeenth' :
                  { 'start' : datetime(1600, 1, 1), 'end' : datetime(1699, 12, 31) }, 
              'eighteenth' :
                  { 'start' : datetime(1700, 1, 1), 'end'  : datetime(1799, 12, 31) }, 
              'nineteenth' :
                  { 'start' : datetime(1800, 1, 1), 'end' : datetime(1899, 12, 31) }, 
              'twentieth' :
                  { 'start' : datetime(1900, 1, 1), 'end' : datetime(1999, 12, 31) }, 
              }

regions_short = ('lowm', 'midm', 'uppm', 'brooklyn', 'queens', 'staten', 'longisland', 'easternli')
regions_long = ('Lower Manhattan', 'Mid Manhattan', 'Upper Manhattan', 'Brooklyn', 'Queens', 'Staten Island', 'Western Long Island', 'Eastern Long Island')
REGIONS = [(0, None)] + zip(regions_short, regions_long)

"""
There are many-to-many Places and Lessons
There are many Image and Video Assets to one Place
There is one MapPatch for each Place
There are many Map Patches for Each Map Assets
"""

def fix(text):
    text = text.replace('<br>','<br />')
    return text

class Place(SQLObject):
    """
    A Place (aka location) in the maap app
    """
    
    class sqlmeta:
        # default sort order
        defaultOrder = 'title'
        
    name = UnicodeCol(default=u'')
    title = UnicodeCol(default=u'')
    body = UnicodeCol(default=u'')
    attribution = UnicodeCol(default=u'')
    now_text = UnicodeCol(default=u'')
    then_text = UnicodeCol(default=u'')
    start_date = DateTimeCol(default=datetime.now)
    end_date = DateTimeCol(default=datetime.now)
    latitude  = FloatCol(default=0)
    longitude = FloatCol(default=0)
    region = UnicodeCol(default=u'')

    # special assets
    featured_image = ForeignKey('ImageAsset', default=None)
    featured_video = ForeignKey('VideoAsset', default=None)
    now_image = ForeignKey('ImageAsset', default=None)
    then_image = ForeignKey('ImageAsset', default=None)
    
    # relations
    lessons = RelatedJoin('Lesson')
    patch = ForeignKey('MapPatch', default=None)
    images =  RelatedJoin('ImageAsset')
    videos = RelatedJoin('VideoAsset')
    
    def rendered_body(self):
        return fix(self.body)

    def rendered_attribution(self):
        # I may not have an attribution attribute, since I was added late in the game
        try:
            fixed = fix(self.attribution) 
        except:
            fixed = ''
        return fixed
    
    def _get_body_snippet(self):
        x = fix(self.body)
        if x.startswith('<p>'):
            return x[3:x.find('.')]
        else:
            return x[:x.find('.')]
        
    
    def rendered_now_text(self):
        return fix(self.now_text)
    
    def rendered_then_text(self):
        return fix(self.then_text)

    def _get_color(self):
        return self.getMarkerColor()

    def getMarkerColor(self):
        """
        map start_date of the place to the marker color
        """
        color = ""
        if self.start_date <= CENTURIES["seventeenth"]["end"]:
            color = "gold"
        elif self.start_date >= CENTURIES["eighteenth"]["start"] and \
                self.start_date <= CENTURIES["eighteenth"]["end"]:
            color = "blue"
        elif self.start_date >= CENTURIES["nineteenth"]["start"] and \
                self.start_date <= CENTURIES["nineteenth"]["end"]:
            color = "purple"
        elif self.start_date >= CENTURIES["twentieth"]["start"]:
            color = "red"
        else: 
            color = "brown"

        return color

    def isImageFeatured(self):
        if not self.featured_image == None:
            return True
        else:
            return False

    def isVideoFeatured(self):
        if not self.featured_video == None:
            return True
        else:
            return False

    def getFeaturedAsset(self):
        """returns featured image or video"""
        if self.isImageFeatured():
            return self.featured_image
        else:
            return self.featured_video

    def getSupplementalAssets(self):
        """returns assets that are _not_ then/now/featured"""
        images = self.images
        videos = self.videos
        return 
        
    # currently missing related places
    # keywords ? 
    def _create(self, id, **kw):
        """
        override create - create a mappatch for every place 
        (there is a one-to-one relationship, and this makes editing UI cleaner
        """
        SQLObject._create(self, id, **kw)
        self.set(patch = MapPatch(name="%s's Patch" % kw['name']))
            
	
class Module(SQLObject):
    """
    A Module contains lessons
    """
    class sqlmeta:
        # default sort order
        defaultOrder = 'name'
        
    name     = UnicodeCol(default=u'')
    title = UnicodeCol(default=u'')
    essential_questions = UnicodeCol(default=u'')
    understandings = UnicodeCol(default=u'')

    # relations
    lessons =  MultipleJoin('Lesson')

    def rendered_essential_questions(self):
        return fix(self.body)

    def rendered_understandings(self):
        return fix(self.body)

class Lesson(SQLObject):
    """
    A Lesson Plan in the maap app
    """
    
    class sqlmeta:
        # default sort order
        defaultOrder = 'name'
        
    name = UnicodeCol()
    title = UnicodeCol(default=u'')
    goals = UnicodeCol(default=u'')
    essential_questions = UnicodeCol(default=u'')
    lesson_url = UnicodeCol(default='')
    
    # lesson images?
    # keywords ? 
    
    # relations
    places = RelatedJoin('Place')
    module = ForeignKey('Module', default=None)

    def rendered_essential_questions(self):
        return fix(self.body)

    def rendered_goals(self):
        return fix(self.body)
    
class MapAsset(SQLObject):
    """
    Historic Maps are special Assets
    """	
    class sqlmeta:
        # default sort order
        defaultOrder = 'name'

    name     = UnicodeCol(default=u'') #root file name
    title = UnicodeCol(default=u'')
    details = UnicodeCol(default=u'')
    source = UnicodeCol(default=u'') #html
    publisher = UnicodeCol(default=u'')
    cartographer = UnicodeCol(default=u'')
    date = DateTimeCol(default=datetime.now)
    scale = UnicodeCol(default=u'1:1')
    coverage = UnicodeCol(default=u'')
    #with name field constructs thumb urls, etc.
    base_url = UnicodeCol(default=u'') 

    def _get_source_html(self):
        return self.source.replace('&','&amp;')

    def _get_smallthumb_url(self):
        return self.base_url + '/65/' + self.name + '_65.jpg'

    def _get_thumb_url(self):
        return self.base_url + '/100x100/' + self.name + '_100x100.jpg'

    def _get_bigthumb_url(self):
        return self.base_url + '/x160/' + self.name + '_x160.jpg'

    def _get_src_url(self):
        return self.base_url + '/550x550/' +self.name + '_550x550.jpg'

    def _get_big_url(self):
        #return self.base_url + '/big/' + self.name + '_big.jpg'
        return self.base_url + '/2000x2000/' + self.name + '_2000x2000.jpg'

    def _get_gigantic_url(self):
        return self.base_url + '/gigantic/' + self.name + '_gigantic.jpg'


    def _get_year(self):
        if self.date:
            return self.date.year
        else:
            return 0

    def _get_yearpos(self):
        if self.date:
            yearpos = (self.date.year-1630)*94/378
            return yearpos
        else:
            return 0

    def _get_vert(self):
        return (self.id % 2) * 11
    # relations
    patches = MultipleJoin('MapPatch', joinColumn="parent_map_id")

class MapPatch(SQLObject):
    """
    MapPatches are crops of MapAssets full images
    these will likely be specified with a url to the zoom/origin of the parent map, but 
    as a fallback, we may crop images and reference these directly
    """
    name = UnicodeCol(default=u'')
    src_url = UnicodeCol(default=u'')
    
    # relations
    parent_map = ForeignKey('MapAsset', default=None)

    def _get_img_url(self):
        return 'http://maap.columbia.edu/content/maps/crop/patch_%d_207x207.jpg' % self.id

class ImageAsset(SQLObject):
    """
    Image Assets 
    """
    class sqlmeta:
        # default sort order
        defaultOrder = 'name'

    name      = UnicodeCol(default=u'') # complete image file name, with extensino
    title     = UnicodeCol(default=u'') # alt text
    source    = UnicodeCol(default=u'')
    creator   = UnicodeCol(default=u'')
    caption   = UnicodeCol(default=u'') # then/now text
    rights    = UnicodeCol(default=u'')
    subject   = UnicodeCol(default=u'')
    base_url = UnicodeCol(default=u'')

    def _get_src_url(self):
        return self.base_url + '/' + self.name

    def _get_thumb_url(self):
        try:
            base_name, ext = self.name.split('.')
        except:
            print "blah, bad name on this image: %s" % self.name
            return ""

        return self.base_url + '/thumbs/' + base_name + '_100x100.jpg'

    def _get_thennow_url(self):
        try:
            base_name, ext = self.name.split('.')
        except:
            print "blah, bad name on this image: %s" % self.name
            return ""

        return self.base_url + '/274/' + base_name + '_274.jpg'
    
    def _get_big_url(self):
        try:
            base_name, ext = self.name.split('.')
        except:
            print "blah, bad name on this image: %s" % self.name
            return ""

        return self.base_url + '/820/' + base_name + '_820.jpg'
    
    # relations
    #place = ForeignKey('Place', default=None)
    place = RelatedJoin('Place')

    def rendered_source(self):
        return '<div>' + fix(self.source).encode('utf8') + '</div>'

class VideoAsset(SQLObject):
    """
    Video Assets
    """
    class sqlmeta:
        # default sort order
        defaultOrder = 'name'

    name       = UnicodeCol(default=u'')
    title      = UnicodeCol(default=u'') # alt text
    source     = UnicodeCol(default=u'')
    caption    = UnicodeCol(default=u'')
    rights     = UnicodeCol(default=u'')
    subject    = UnicodeCol(default=u'')

    thumb_url  = UnicodeCol(default='')
    stream_url = UnicodeCol(default='')
    # we will dervie the download_url from the stream_url
    # download_url = UnicodeCol(default='')

    # relations
    #place = ForeignKey('Place', default=None)
    place = RelatedJoin('Place')

    def rendered_source(self):
        return fix(self.body)

    def _get_tiny_url(self):
        try:
            last_slash_idx = self.thumb_url.rfind('/')
            base_url = self.thumb_url[:last_slash_idx]
            filename = self.thumb_url[last_slash_idx:]
        except:
            print "blah, bad thumburl on this image: %s" % self.name
            return ""

        return base_url + '/80x60' + filename

    def _get_download_url(self):
        try:
            #last_slash_idx = self.thumb_url.rfind('/')
            #base_url = self.stream_url[:last_slash_idx]
            #filename = self.thumb_url[last_slash_idx:]
            last_dot_idx = self.stream_url.rfind('.')
            base_url = self.stream_url[:last_dot_idx]
        except:
            print "blah, bad thumburl on this image: %s" % self.name
            return ""

        return base_url + '.mov'

    def _get_audio_url(self):
        try:
            #last_slash_idx = self.thumb_url.rfind('/')
            #base_url = self.stream_url[:last_slash_idx]
            #filename = self.thumb_url[last_slash_idx:]
            last_dot_idx = self.stream_url.rfind('.')
            base_url = self.stream_url[:last_dot_idx]
        except:
            print "blah, bad streamurl on this asset: %s" % self.name
            return ""

        return base_url + '.mp3'

        


# identity models.
class Visit(SQLObject):
    """
    A visit to your site
    """
    class sqlmeta:
        table = 'visit'

    visit_key = StringCol(length=40, alternateID=True,
                          alternateMethodName='by_visit_key')
    created = DateTimeCol(default=datetime.now)
    expiry = DateTimeCol()

    def lookup_visit(cls, visit_key):
        try:
            return cls.by_visit_key(visit_key)
        except SQLObjectNotFound:
            return None
    lookup_visit = classmethod(lookup_visit)


class VisitIdentity(SQLObject):
    """
    A Visit that is link to a User object
    """
    visit_key = StringCol(length=40, alternateID=True,
                          alternateMethodName='by_visit_key')
    user_id = IntCol()


class Group(SQLObject):
    """
    An ultra-simple group definition.
    """
    # names like "Group", "Order" and "User" are reserved words in SQL
    # so we set the name to something safe for SQL
    class sqlmeta:
        table = 'tg_group'

    group_name = UnicodeCol(length=16, alternateID=True,
                            alternateMethodName='by_group_name')
    display_name = UnicodeCol(length=255)
    created = DateTimeCol(default=datetime.now)

    # collection of all users belonging to this group
    users = RelatedJoin('User', intermediateTable='user_group',
                        joinColumn='group_id', otherColumn='user_id')

    # collection of all permissions for this group
    permissions = RelatedJoin('Permission', joinColumn='group_id',
                              intermediateTable='group_permission',
                              otherColumn='permission_id')


class User(SQLObject):
    """
    Reasonably basic User definition.
    Probably would want additional attributes.
    """
    # names like "Group", "Order" and "User" are reserved words in SQL
    # so we set the name to something safe for SQL
    class sqlmeta:
        table = 'tg_user'

    user_name = UnicodeCol(length=16, alternateID=True,
                           alternateMethodName='by_user_name')
    email_address = UnicodeCol(length=255, alternateID=True,
                               alternateMethodName='by_email_address')
    display_name = UnicodeCol(length=255)
    password = UnicodeCol(length=40)
    created = DateTimeCol(default=datetime.now)

    # groups this user belongs to
    groups = RelatedJoin('Group', intermediateTable='user_group',
                         joinColumn='user_id', otherColumn='group_id')

    def _get_permissions(self):
        perms = set()
        for g in self.groups:
            perms = perms | set(g.permissions)
        return perms

    def _set_password(self, cleartext_password):
        "Runs cleartext_password through the hash algorithm before saving."
        password_hash = identity.encrypt_password(cleartext_password)
        self._SO_set_password(password_hash)

    def set_password_raw(self, password):
        "Saves the password as-is to the database."
        self._SO_set_password(password)


class Permission(SQLObject):
    """
    A relationship that determines what each Group can do
    """
    permission_name = UnicodeCol(length=16, alternateID=True,
                                 alternateMethodName='by_permission_name')
    description = UnicodeCol(length=255)

    groups = RelatedJoin('Group',
                         intermediateTable='group_permission',
                         joinColumn='permission_id',
                         otherColumn='group_id')

