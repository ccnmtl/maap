import logging

import cherrypy
from cherrypy import request,response

import turbogears
from turbogears import controllers, expose, validate, redirect
from turbogears import identity
from turbogears import config
from turbogears import validators

from tgstatic import StaticPublisher,static,s_url

from os.path import dirname
import os
from maap import json

from simplejson import dumps as serializeJSON

from maap.model import Place, Module, Lesson, MapAsset, MapPatch, ImageAsset, VideoAsset, REGIONS, regions_short

# try out sky's crud magic
from restresource import *
from restresource.crud import *

log = logging.getLogger("maap.controllers")

import webhelpers
def add_custom_stdvars(vars):
	return vars.update({"s_url": lambda x: "%s" % x, 
			    "static" : lambda: False, 
			    "h" : webhelpers,
			    "gmap_key" : config.get('gmap_key') })	

turbogears.view.variable_providers.append(add_custom_stdvars)

class ConvertZeroToNone(validators.FancyValidator):
	"""
	a validator which converts 0 to None, otherwise leaves unchanged
	"""
	def _to_python(self, value, state):
		if value == 0 or value == '0':
			return None
		else:
			return value
		
def get_video_options():
	"""
	returns options to featured/now/then selection on place admin form 
	"""
	# this is a miserable hack, but the widgets don't pass parameters
	# at render-time, so here I am, figuring out what place I am at from 
	# the url
	# also, no convinience methods to discect the url easily
	resource, action = request.path.split(';')
	if action == 'add_form':
		return [(0, 'None')]
	parts = resource.split("/")
	place_id = parts[-2] # this is (hopefully, my place id)
	place = Place.selectBy(id = int(place_id))
	if place.count() == 0:
		return [(0, 'None')]
	else:
		place = place[0]
		return [(0, 'None')] + [(video.id, video.name) for video in list(place.videos)]

def get_image_options():
	"""
	returns options to featured/now/then selection on place admin form 
	"""
	resource, action = request.path.split(';')
	if action == 'add_form':
		return [(0, 'None')]
	parts = resource.split("/")
	place_id = parts[-2] # this is (hopefully, my place id)
	place = Place.selectBy(id = int(place_id))
	if place.count() == 0:
		return [(0, 'None')]
	else:
		place = place[0]
		return [(0, 'None')] + [(image.id, image.name) for image in list(place.images)]

class AdminCrudController(CrudController,RESTResource):
	"""
	Base admin controller
	"""
	def update_success(self, table,**kw):
		# use rest resource's tokenizer to strip out ';'
		redirect_path = self.parse_resource_token(request.path)[0]
		raise redirect(redirect_path)
	
	#same as update_success
	create_success = update_success

	@expose(template='.templates.edit', format="xhtml", accept_format="text/html")
	def get_edit_form(self, table, **kw):
		return self.crud.edit_form(self,table,**kw)
	get_edit_form.expose_resource = True
	
	
	@expose(template='.templates.add', format="xhtml", accept_format="text/html")
	def get_add_form(self, **kw):
		return self.crud.add_form(self,**kw)

	get_add_form.expose_resource = True
	
class PlaceAdminController(AdminCrudController):
	#'crud' is a magic word.  You must use 'crud' as the variable
	crud = SOController(Place)


	def initfields(self, action, field_dict):
		field_dict['body'] = TextArea(name='body',
					      label='Body',
					      validator=validators.NotEmpty())
		field_dict['now_text'] = TextArea(name='now_text',
					      label='Now Text Snippet',
					      validator=validators.NotEmpty())
		field_dict['then_text'] = TextArea(name='then_text',
					      label='Then Text Snippet',
					      validator=validators.NotEmpty())
		field_dict['featured_imageID'] = SingleSelectField(name='featured_imageID',
								   label='Featured Image',
								   options=get_image_options,
								   validator=validators.Any(validators.Int(),validators.Empty(),ConvertZeroToNone()),
								   )
		field_dict['featured_videoID'] = SingleSelectField(name='featured_videoID',
								   label='Featured Video',
								   options=get_video_options,
								   validator=validators.Any(validators.Int(),validators.Empty(),ConvertZeroToNone()),

								   )
		field_dict['now_imageID'] = SingleSelectField(name='now_imageID',
								   label='Now Image',
								   options=get_image_options,
							           validator=validators.Any(validators.Int(),validators.Empty(),ConvertZeroToNone()),

							      )
		field_dict['then_imageID'] = SingleSelectField(name='then_imageID',
								   label='Then Image',
								   options=get_image_options,
								   validator=validators.Any(validators.Int(),validators.Empty(),ConvertZeroToNone())
							       )
		field_dict['region'] = SingleSelectField(name='region',
							 label='Region',
							 options=REGIONS,
							 validator=validators.NotEmpty(),
		)
	


		# labels
		# field_dict['something'].label = 'Something Else'
		return field_dict
						      
	@expose(template='.templates.admin_places_list')
	def list(self, **kw):
		#return self.search(**kw)
		places = list(Place.select())
		return dict(places=places)
	list.expose_resource = True

	@expose(template=".templates.admin_place_view")
	def read(self, table, **kw):
		return dict(place=table, 
			    columns=self.crud.columns().keys(),
			    )
	read.expose_resource = True

	@expose(template='.templates.admin_place_edit', format="xhtml", accept_format="text/html")
	def get_edit_form(self, table, **kw):
		return self.crud.edit_form(self,table,**kw)
	get_edit_form.expose_resource = True

class ModuleAdminController(AdminCrudController):
	#'crud' is a magic word.  You must use 'crud' as the variable
	crud = SOController(Module)

	def initfields(self, action, field_dict):
		field_dict['understandings'] = TextArea(name='understandings',
					       label='Understandings',
					       validator=validators.NotEmpty())
		field_dict['essential_questions'] = TextArea(name='essential_questions',
							     label='Essential Questions',
							     validator=validators.NotEmpty())
		return field_dict
	
	@expose(template='.templates.admin_modules_list')
	def list(self, **kw):
		#return self.search(**kw)
		modules = list(Module.select())
		return dict(modules=modules)
	list.expose_resource = True

	@expose(template=".templates.admin_module_view")
	def read(self, table, **kw):
		return dict(maap_module=table, 
			    columns=self.crud.columns().keys(),
			    )
	read.expose_resource = True


class LessonAdminController(AdminCrudController):
	#'crud' is a magic word.  You must use 'crud' as the variable
	crud = SOController(Lesson)

	def initfields(self, action, field_dict):
		field_dict['goals'] = TextArea(name='goals',
					       label='Goals',
					       validator=validators.NotEmpty())
		field_dict['essential_questions'] = TextArea(name='essential_questions',
							     label='Essential Questions',
							     validator=validators.NotEmpty())
		return field_dict

	@expose(template='.templates.admin_lessons_list')
	def list(self, **kw):
		#return self.search(**kw)
		lessons = list(Lesson.select())
		return dict(lessons=lessons)
	list.expose_resource = True

	def update_success(self, table,**kw):
		raise redirect("/admin/module/%s" % self.parents[0].id)
	create_success = update_success

						      
class MapAssetAdminController(AdminCrudController):
	#'crud' is a magic word.  You must use 'crud' as the variable
	crud = SOController(MapAsset)

	def initfields(self, action, field_dict):
		field_dict['source'] = TextArea(name='source',
					       label='Source',
					       validator=validators.NotEmpty())
		return field_dict

	@expose(template='.templates.admin_maps_list')
	def list(self, **kw):
		#return self.search(**kw)
		maps = list(MapAsset.select())
		return dict(maps=maps)
	list.expose_resource = True

	def update_success(self, table,**kw):
		raise redirect("/admin/map/") #%s" % table.id)
	create_success = update_success
	
class MapPatchAdminController(AdminCrudController):
	#'crud' is a magic word.  You must use 'crud' as the variable
	crud = SOController(MapPatch)

	def initfields(self, action, field_dict):
		field_dict['parent_mapID'] = SingleSelectField(
			name='parent_mapID',
			label='Map',
			options=[(map.id, map.name)
				 for map in MapAsset.select()],
			validator=validators.Any(validators.Int(),validators.Empty()),
			)
		return field_dict

	@expose(template='.templates.admin_patch_edit', format="xhtml", accept_format="text/html")
	def get_edit_form(self, table, **kw):
		kw['maps'] = list(MapAsset.select())
		return self.crud.edit_form(self,table,**kw)
	get_edit_form.expose_resource = True
	
	def update_success(self, table,**kw):
		"""
		return to /admin/place/<id> after editing patch 
		"""
		# minor hack. patches and placees have the same id
		# since patches are pre-created automatically upon place creation
		raise redirect("/admin/place/%s" % table.id)
	create_success = update_success


class ImageAssetAdminController(AdminCrudController):
	#'crud' is a magic word.  You must use 'crud' as the variable
	crud = SOController(ImageAsset)


	def initfields(self, action, field_dict):
		field_dict['source'] = TextArea(name='source',
					       label='Source',
					       validator=validators.NotEmpty())
		return field_dict

	# override create so we can establish the place-image association
	# this assumes that add_form will be called on image when place is in the url
	# e.g. http://kodos.ccnmtl.columbia.edu:9091/admin/place/13/image/;add_form

	@expose()
	def create(self,table,**kw):
		kw = self.crud.create_validation(self,**kw)
		if error_response(kw):
			return kw
		else:
			image = self.crud.create(self,table,**kw)
			if error_response(image):
				return image
			place = self.parents[0]
			place.addImageAsset(image)
			return self.create_success(table, **kw)
	create.expose_resource = True

	def update_success(self, table,**kw):
		raise redirect("/admin/place/%s" % self.parents[0].id)
	create_success = update_success


class VideoAssetAdminController(AdminCrudController):
	#'crud' is a magic word.  You must use 'crud' as the variable
	crud = SOController(VideoAsset)

	def initfields(self, action, field_dict):
		field_dict['source'] = TextArea(name='source',
					       label='Source',
					       validator=validators.NotEmpty())
		return field_dict

	@expose()
	def create(self,table,**kw):
		kw = self.crud.create_validation(self,**kw)
		if error_response(kw):
			return kw
		else:
			video = self.crud.create(self,table,**kw)
			if error_response(video):
				return video
			place = self.parents[0]
			place.addVideoAsset(video)
			return self.create_success(table, **kw)
	create.expose_resource = True

	def update_success(self, table,**kw):
		raise redirect("/admin/place/%s" % self.parents[0].id)
	create_success = update_success

class AdminController(controllers.Controller):
	place = PlaceAdminController()
	module = ModuleAdminController()
	map = MapAssetAdminController()
	patch = MapPatchAdminController()

	module.REST_children = {
		'lesson' : LessonAdminController()
		}

	place.REST_children = {
		'image':ImageAssetAdminController(),
		'video':VideoAssetAdminController(),
		'patch':MapPatchAdminController(),
		}

	map.REST_children = {
		'patch':MapPatchAdminController(),
		}
	
	@expose(template=".templates.admin_main")
	def index(self):
		return dict()
	
	
class PlaceController(controllers.Controller):
	@expose(template=".templates.now-places")
	def index(self, order_by="Place.q.name", **kw):
		places = list(Place.select())
		return dict(places=places)

	@expose(template=".templates.then-places")
	def then(self, **kw):
		"""What do we need?
		   places: to list them on the right
		   patches: to annotate them on the map
		   maps: to switch between them
		"""
		places = list(Place.select())
		maps = list(MapAsset.select())
		maps = sorted(maps,key=lambda x:x.year)
		map_vert = []
		for i,m in enumerate(maps):
			if i!=0 and m.yearpos-maps[i-1].yearpos < 5 and map_vert[i-1] < 4:
				map_vert.append(map_vert[i-1] + 1)
			else:
				map_vert.append(1)
		return dict(places=places,
			    maps = maps,
			    map_vert = map_vert
			    )

	@expose("json")
	def json(self, callback=True, **kw):
		places = [dict(id=p.id,
			       latitude=p.latitude,
			       longitude=p.longitude,
			       title=p.title,
			       color=p.color,
			       )
			  for p in Place.select()]
		rv = dict(places=places)
		if callback:
			return 'loadPlaces(%s)' % serializeJSON(rv)
		else:
			return rv

	@expose("json")
	def maps(self, callback=True, **kw):

		maps = dict([(m.name,dict(name=m.name,
					  id=m.id,
					  title = m.title,
					  publisher = m.publisher,
					  date = m.date.isoformat(),
					  year = m.year,
					  thumb_url = m.thumb_url,
					  images = dict(preview = m.src_url,
							thumb = m.thumb_url,
							smallthumb = m.smallthumb_url,
							bigthumb = m.bigthumb_url,
							big = m.big_url,
							gigantic = m.gigantic_url,
							)
					  ))
			     for m in MapAsset.select()])
		#we don't need patches at this moment.  maybe later?
		patches = [] #json.jsonify_sqlobject(mp) for mp in MapPatch.select()]
		rv = dict(maps=maps,
			  patches=patches)
		if callback:
			return 'loadMaps(%s)' % serializeJSON(rv)
		else:
			return rv
		
	@expose("json")
	def welcome_places(self, callback=True, **kw):
		FEATURED_PLACE_NAMES = ("pierre_toussaint",
					"abyssinian_baptist_church",
					"african_grove_theater",
					"duke_ellington",
					"five_points",
					"fort_amsterdam",
					"harlem",
					"studio_museum",  
					"the_african_burial_ground",
					"the_audubon_ballroom")
		featured_places = [Place.selectBy(name=p)[0] for p in FEATURED_PLACE_NAMES]
		
		places = dict([(index,dict(name=p.name,
					    id=p.id,
					    title = p.title,
					    then_text = p.then_text,
					    then_image_id = p.then_image.id,
					    then_image_thumb_url = p.then_image.thennow_url,
					    ))
			       for index, p in enumerate(featured_places)])
		rv = dict(places=places)
		if callback:
			return 'loadFeaturedPlaces(%s)' % serializeJSON(rv)
		else:
			return rv
		
	@expose(template=".templates.now_patch_test")
	def now_patch_test(self, place_id, **kwargs):
		place = Place.get(int(place_id))
		#cdata_description = "<blah><![CDATA[" + place.description + "]]></blah>",
		
		return dict(places = list(Place.select()),
			    place=place,
			    cdata_body = "<![CDATA[" + place.body + "]]>",
			    patch = place.patch,
			    featured_image = place.featured_image,
			    featured_video = place.featured_video,
			    then_image = place.then_image,
			    now_image = place.now_image,
			    images = list(place.images),
			    videos = list(place.videos),
			    related_lessons = list(place.lessons),
			    )		

	
	@expose(template=".templates.place")
	def default(self, place_id, **kwargs):
		place = Place.get(int(place_id))
		#cdata_description = "<blah><![CDATA[" + place.description + "]]></blah>",
		
		return dict(places = list(Place.select()),
			    place=place,
			    cdata_body = "<![CDATA[" + place.body + "]]>",
			    patch = place.patch,
			    featured_image = place.featured_image,
			    featured_video = place.featured_video,
			    then_image = place.then_image,
			    now_image = place.now_image,
			    images = list(place.images),
			    videos = list(place.videos),
			    related_lessons = list(place.lessons),
			    )

class ModuleController(controllers.Controller):
	@expose(template=".templates.modules")
	def index(self):
		modules = list(Module.select())
		return dict(maap_modules=modules)
	
	@expose(template=".templates.module")
	def default(self, module_id, **kwargs):
		module = Module.get(int(module_id))
		lessons = list(module.lessons)
		#import pdb; pdb.set_trace()
		return dict(maap_module=module,
			    lessons=lessons,
			    )

class LessonController(controllers.Controller):
	# not sure if we will keep exposing lessons.
	@expose(template=".templates.lessons")
	def index(self, order_by="Lesson.q.name"):
		lessons = list(Lesson.select())
		return dict(lessons=lessons)
	
	@expose(template=".templates.lesson")
	def default(self, lesson_id, **kwargs):
		lesson = Lesson.get(int(lesson_id))
		return dict(lesson=lesson,
			    parent_module=lesson.module,
			    related_places = list(lesson.places),
			    )

class MapController(controllers.Controller):
	@expose(template=".templates.image_view")
	def default(self, map_id, **kwargs):
		try: 
			map = list(MapAsset.selectBy(id=map_id))[0]
		except:
			map = None
	       	return dict(image=map)
	

class VideoController(controllers.Controller):
	@expose(template=".templates.video_view")
	def default(self, video_id, **kwargs):
		try: 
			video = list(VideoAsset.selectBy(id=video_id))[0]
		except:
			log("video not found")
			video = None
	       	return dict(video=video)
	
	view = default

class ImageController(controllers.Controller):
	@expose(template=".templates.image_view")
	def default(self, image_id, **kwargs):
		try: 
			image = list(ImageAsset.selectBy(id=image_id))[0]
		except:
			log("image not found")
			image = None
	       	return dict(image=image)
	


	@expose(template=".templates.image_view")
	def view(self, image_id, **kwargs):
		try: 
			image = list(ImageAsset.selectBy(id=image_id))[0]
		except:
			log("image not found")
			image = None
		return dict(image=image)

class Root(RESTResource, controllers.RootController):
    admin = AdminController()
    place = PlaceController()
    module = ModuleController()
    lesson = LessonController()
    #library = LibraryController()
    map = MapController()
    video = VideoController()
    image = ImageController()

    @expose()
    def index(self):
	    raise redirect("/welcome")

    @expose(template=".templates.welcome")
    def welcome(self):
	    return dict()

    @expose(template=".templates.search_results")
    def search_results(self, **kwargs):
	    return dict()
    
    @expose(template=".templates.about")
    def about(self):
	    return dict()

    @expose(template=".templates.help")
    def help(self):
	    return dict()
    
    @expose(template=".templates.contact")
    def contact(self):
	    return dict()

    @expose(template=".templates.contactconfirm")
    def contactconfirm(self):
	    return dict()

    @expose(template=".templates.podcast")
    def podcast(self):
	    return dict()

    @expose(template=".templates.partners")
    def partners(self):
	    return dict()

    @expose(template=".templates.full_export_mt")
    def full_export_mt(self):
	    places = list(Place.select())
	    return dict(places=places)
    
    # mobile view - jqtouch driven
    @expose(template=".templates.mbl_index")
    def mbl_index(self):
	    all_places = list(Place.select())

	    # hard-code the removal of 2 places that aren't ready for the mobile page
	    places = [p for p in all_places if (p.name !='lattings' and p.name != 'setauket')]

	    # compute the number of places in each region for mobile view
	    region_counts = {}
	    region_counts['all'] = len(places)
	    for r in regions_short:
		    region_counts[r] = Place.selectBy(region = r).count()

	    return dict(places=places, region_counts=region_counts)

    @expose(template=".templates.mbl_place")
    def mbl_place(self, place_id, **kwargs):
	    try:
		    places = Place.selectBy(id = int(place_id))
		    if places.count() == 0:
			    place = ''
		    else: 
			    place = places[0]
		    print "I made it"
	    except:
		    print "Uh oh"
		    raise Exception("help")
	    return dict(place=place)
	    #return dict(place=None)

    
    @expose(template=".templates.library")
    def maap_library(self, type='images', **kw):
	class Asset():
	    def __init__(self, asset_type=None, record=None, thumb_url=None, view_url=None):
	        self.asset_type = asset_type
		self.record = record
		self.name = record.name
		self.thumb_url = thumb_url
		self.view_url = view_url

	    def __cmp__(self,other):
	        return cmp(self.name,other.name)
	
	if type == 'maps':
		maps = MapAsset.selectBy()
		assets = [Asset(asset_type='map',record=m, thumb_url=m.smallthumb_url,  view_url="/place/then#map=%s" % m.name) for m in maps]
	elif type == 'videos':
		videos = VideoAsset.selectBy()
		assets = [Asset(asset_type='video',record=v, thumb_url=v.tiny_url, view_url="/video/view/%s" % v.id) for v in videos]
	else:
		images = ImageAsset.selectBy()
		assets = [Asset(asset_type='image',record=i, thumb_url=i.thumb_url, view_url="/image/view/%s" % i.id) for i in images]

	assets.sort()
        return dict(assets=assets,
		    type=type)


    @expose(template="maap.templates.main")
    def default(self,dir="",slug="index"):
        if dir == "":
            include_document = "%s/static/content/%s.html" % (dirname(__file__),slug)
        else:
            include_document = "%s/static/content/%s/%s.html" % (dirname(__file__),dir,slug)
        try:
            os.stat(include_document)
        except OSError:
            raise cherrypy.NotFound

        data = dict(slug=slug,dir=dir,include_document=include_document,project="maap")
        # templates
        if dir != "":
            data['tg_template'] = "maap.templates.%s" % dir
        
        return data

    @expose(template=".templates.login")
    def login(self, forward_url=None, previous_url=None, *args, **kw):
	    if not identity.current.anonymous \
			and identity.was_login_attempted() \
			and not identity.get_identity_errors():
		    raise redirect(forward_url)

        #forward url will only be set if not passed from
        #a previous login attempt.
        # Case 1: user went to page that serves login page for credential reqs
        # Case 2: public page offered login, so forward_url returns to the referrer
        # note: case 2 was not in original TG code
	    forward_url=None
	    previous_url= request.path
	    
	    if identity.was_login_attempted():
		    msg=_("The credentials you supplied were not correct or "
			  "did not grant access to this resource.")
	    elif identity.get_identity_errors():
		    response.status=401
		    msg=_("You must provide your credentials before accessing this resource.")
		    forward_url = previous_url
	    else:
		    msg=_("Please log in.")
		    forward_url= request.headers.get("Referer", "/")
	
	    return dict(message=msg, previous_url=previous_url, logging_in=True,
			original_parameters=request.params,
			forward_url=forward_url)

    @expose()
    def logout(self):
	    identity.current.logout()
	    raise redirect("/")
