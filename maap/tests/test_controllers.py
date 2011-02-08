import unittest
import turbogears
from turbogears import testutil
from maap.controllers import Root
import cherrypy

cherrypy.root = Root()
# identity testing tips
# http://www.thesamet.com/blog/2006/06/02/four-tips-on-identity-testing/

turbogears.config.update({
        'visit.on': True,
        'identity.on': True,
        'identity.failure_url': '/login',
        })

class TestPages(unittest.TestCase):

    def setUp(self):
        turbogears.startup.startTurboGears()

    def tearDown(self):
        """Tests for apps using identity need to stop CP/TG after each test to
        stop the VisitManager thread. 
        See http://trac.turbogears.org/turbogears/ticket/1217 for details.
        """
        turbogears.startup.stopTurboGears()

    def test_method(self):
        "the welcome method returns an empty dict"
        import types
        result = testutil.call(cherrypy.root.welcome)
        assert type(result) == types.DictType

    def test_welcometitle(self):
        "The indexpage should have the right title"
        testutil.createRequest("/welcome")
        response = cherrypy.response.body[0].lower() 
        assert "<title>maap: mapping the african-american past</title>" in response

    def test_logintitle(self):
        "login page should have the right title"
        testutil.createRequest("/login")
        response = cherrypy.response.body[0].lower()
        # print response
        assert "<title>login</title>" in response
