from maap.model import *
#The best way to init the data is first run
# $ tg-admin sql create
#Once you've done that, run
# $ tg-admin shell
# >>> import init_brownfield
# >>> [Control-D]
# and when asked if you want to commit the db changes, type 'yes', Enter


#Places
columbia = Place(name="columbia",
                 title="Columbia University",
                 body="""An Ivy League University the Upper West Side""",
                 latitude=3.14,
                 longitude=2.18,
                 start_date=datetime(1701,1,1),
                 # end_date
                 )

lalo = Place(name="lalo",
             title="Cafe Lalo",
             body="Desserts and Lights",
             longitude=1.1,
             latitude=2.1,
             start_date=datetime(1801,1,1),
)

home = Place(name="home",
             title="Cafe Lalo",
             body="Home Sweet Home",
             longitude=2.3,
             latitude=3.4,
             start_date=datetime(2001,1,1),
)

module1 = Module(name="module1",
                 title="The First Module",
                 essential_questions="Who? What? When? Where? Why?",
                 understandings="yes")

module2 = Module(name="module2",
                 title="The Second Module",
                 essential_questions="Who? What? When? Where? Why?",
                 understandings="no")

lesson1a = Lesson(name="lesson1a",
                 title = "The First Lesson",
                 goals = "The First Lesson's goals",
                 essential_questions = "The First Lessons's questions",
                 lesson_url = "/lesson/1",
                 module=module1
                 )

lesson1b = Lesson(name="lesson1b",
                 title = "The Second Lesson",
                 goals = "The Second Lesson's goals",
                 essential_questions = "The First Lessons's questions",
                 lesson_url = "/lesson/2",
                 module=module1
                 )

lesson2a = Lesson(name="lesson2a",
                 title = "The TwoA Lesson",
                 goals = "The TwoA Lesson's goals",
                 essential_questions = "The TwoA Lessons's questions",
                 lesson_url = "/lesson/3",
                 module=module2
                 )

oldmap1 = MapAsset(name="oldmap1",
                   title="Old Map 1")

oldmap2 = MapAsset(name="oldmap2",
                   title="Old Map 2")


image1a = ImageAsset(name="butler_a",
                     source="flickr",
                     base_url="http://columbia.edu/")
columbia.addImageAsset(image1a)

image1b = ImageAsset(name="butler_b",
                     source="flickr",
                     base_url="http://columbia.edu/fullb.png")
columbia.addImageAsset(image1b)

image2a = ImageAsset(name="lalo_a",
                     source="flickr",
                     base_url="http://lalo.com/fulla.png")
lalo.addImageAsset(image2a)

image2b = ImageAsset(name="lalo_b",
                     source="flickr",
                     base_url="http://lalo.com/fullb.png")
lalo.addImageAsset(image2b)

video1a = VideoAsset(name="columbia_video_a",
                     source="youtube",
                     stream_url="http://columbia.edu/columbia_a.avi",
                     thumb_url="http://columbia.edu/thumb_movie_a.png")
columbia.addVideoAsset(video1a)

video1b = VideoAsset(name="columbia_video_b",
                     source="youtube",
                     stream_url="http://columbia.edu/columbia_b.avi",
                     thumb_url="http://columbia.edu/thumb_movie_b.png")
columbia.addVideoAsset(video1b)


video2a = VideoAsset(name="lalo_video_a",
                     source="youtube",
                     stream_url="http://lalo.com/lalo_a.avi",
                     thumb_url="http://lalo.com/thumb_lalo_a.png")
lalo.addVideoAsset(video2a)


video2b = VideoAsset(name="lalo_video_b",
                     source="youtube",
                     stream_url="http://lalo.com/lalo_b.avi",
                     thumb_url="http://lalo.com/thumb_lalo_b.png")
lalo.addVideoAsset(video2b)

# rig up some patches
columbia.patch.set(name="Columbia Patch",
                   src_url="http://google.com",
                   parent_map = oldmap1)
lalo.patch.set(name="Lalo Patch",
                   src_url="http://google.com",
                   parent_map = oldmap2)
home.patch.set(name="HomePatch",
                   src_url="http://google.com",
                   parent_map = oldmap1)
               


# create some place/lesson relations
# the add<Lesson/Place> are symetrical. RelatedJoin will
# do the right thin on selects (but we capture this in tests)

columbia.addLesson(lesson1a)
# columbia.addLesson(lesson2)

lalo.addLesson(lesson1b)
#lalo.addLesson(lesson3)

home.addLesson(lesson2a)
#home.addLesson(lesson3)




