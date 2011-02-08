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
                 latitude=40.803219,
                 longitude=-73.952538,
                 # start_date,
                 # end_date
                 )

lalo = Place(name="lalo",
             title="Cafe Lalo",
             body="Desserts and Lights",
             latitude=40.803219,
             longitude=-73.952538,
             )

home = Place(name="home",
             title="Home",
             body="Home Sweet Home",
             latitude=40.803219,
             longitude=-73.952538,
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
                   title="Old Map 1",
                   thumb_url = "/oldmap1_tmb.png",
                   src_url = "/oldmap1.png")

oldmap2 = MapAsset(name="oldmap2",
                   title="Old Map 2",
                   thumb_url = "/oldmap2_tmb.png",
                   src_url = "/oldmap2.png")


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



# create some place/lesson relations
# the add<Lesson/Place> are symetrical. RelatedJoin will
# do the right thin on selects (but we capture this in tests)

columbia.addLesson(lesson1a)

lalo.addLesson(lesson1b)

home.addLesson(lesson2a)


