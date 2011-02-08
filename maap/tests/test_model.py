# If your project uses a database, you can set up database tests
# similar to what you see below. Be sure to set the db_uri to
# an appropriate uri for your testing database. sqlite is a good
# choice for testing, because you can use an in-memory database
# which is very fast.

from turbogears import testutil, database
# from maap.model import YourDataClass, User

# database.set_db_uri("sqlite:///:memory:")

# class TestUser(testutil.DBTest):
#     def get_model(self):
#         return User
#     def test_creation(self):
#         "Object creation should set the name"
#         obj = User(user_name = "creosote",
#                       email_address = "spam@python.not",
#                       display_name = "Mr Creosote",
#                       password = "Wafer-thin Mint")
#         assert obj.display_name == "Mr Creosote"

import maap.model as model
from maap.model import Place, Module, Lesson, MapAsset, MapPatch, ImageAsset, VideoAsset

soClasses = [Place, Module, Lesson, MapAsset, MapPatch, ImageAsset, VideoAsset]

database.set_db_uri("sqlite:///:memory:?debug=1")

def create_tables():
    for c in soClasses:
        c.createTable(ifNotExists = True)

def drop_tables():
    cs = soClasses[:]
    cs.reverse()
    for c in cs:
        c.dropTable(ifExists=True)


class TestPlace(testutil.DBTest):
    def setUp(self):
        drop_tables()
        create_tables()
        
    #model = Place

    def get_model(self):
        return Place

    def test_creation(self):
        obj = Place(name = "place_1")
        assert obj.name == "place_1"

    def tearDown(self):
        drop_tables()


class TestLesson(testutil.DBTest):
    def setUp(self):
        drop_tables()
        create_tables()

    def get_model(self):
        return Lesson

    def test_creation(self):
        obj = Lesson(name = "lesson_1")
        assert obj.name == "lesson_1"
                    
    def tearDown(self):
        drop_tables()

class TestSampleContent(testutil.DBTest):
    """
    this test loads my test_content.py file and excercises the relations
    """

    def setUp(self):
        drop_tables()
        create_tables()

    def test_relations(self):
        import test_content
        # places = Place.select()

        # test places
        columbia = Place.selectBy(name="columbia")[0]
        assert columbia.name == "columbia"

        lalo = Place.selectBy(name="lalo")[0]
        assert lalo.name == "lalo"


        home = Place.selectBy(name="home")[0]
        assert home.name == "home"

        # map assets and their patches
        maps = MapAsset.select()
        oldmap1 = maps[0]
        # print oldmap1
        patches = oldmap1.patches
        #print patches
        assert patches[0].name == "Columbia Patch"
        
        assert columbia.patch.name == "Columbia Patch"
        
        # images associated with places 
        c_images = columbia.images
        assert c_images[0].name == "butler_a"
        assert c_images[1].name == "butler_b"

        l_images = lalo.images
        assert l_images[0].name == "lalo_a"
        assert l_images[1].name == "lalo_b"
        

        # images associated with places 
        c_videos = columbia.videos
        assert c_videos[0].name == "columbia_video_a"
        assert c_videos[1].name == "columbia_video_b"

        l_videos = lalo.videos
        assert l_videos[0].name == "lalo_video_a"
        assert l_videos[1].name == "lalo_video_b"


        # associated lessons
        c_lessons = list(columbia.lessons)
        assert len(c_lessons) == 1

        c_lessons[0].name == "lesson1a"

        lesson1a = Lesson.selectBy(name="lesson1a")[0]
        l1_places = list(lesson1a.places)
        assert len(l1_places) == 1
        l1_places[0].name == "columbia"
        
        module1 = Module.selectBy(name='module1')[0]
        assert module1.name == "module1"

        lessons = module1.lessons
        lesson1a = lessons[0]
        assert lesson1a.name == "lesson1a"
        assert lesson1a.module.name == "module1"

        # test some date arithmetic
        assert columbia.getMarkerColor() == 'orange'
        assert lalo.getMarkerColor() == 'pink'
        assert home.getMarkerColor() == 'darkgreen'

    def tearDown(self):
        drop_tables()
    
