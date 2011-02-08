PROD_HOST = "monty.ccnmtl.columbia.edu"

def run_unit_tests(pusher):
    codir = pusher.checkout_dir()
    (out,err) = pusher.execute("pushd %s && python setup.py testgears && popd" % codir)
    return ("FAILED" not in out,out,err)

def post_rsync(pusher):
    (out,err) = pusher.execute(["ssh",PROD_HOST,"/bin/rm","/var/www/maap/eggs/psycopg2-2.0.6-py2.5-linux-x86_64.egg"])
    (out,err) = pusher.execute(["ssh",PROD_HOST,"/var/www/maap/init.sh","/var/www/maap/"])
    (out,err) = pusher.execute(["ssh",PROD_HOST,"/bin/ln","-s","/usr/lib/python2.5/site-packages/mx/","/var/www/maap/working-env/lib/python2.5/"])
    (out,err) = pusher.execute(["ssh",PROD_HOST,"/bin/ln","-s","/usr/lib/python2.5/site-packages/psycopg2/","/var/www/maap/working-env/lib/python2.5/"])
    (out2,err2) = pusher.execute(["ssh",PROD_HOST,"sudo","/usr/bin/supervisorctl","restart","maap"])
    out += out2
    err += err2
    return (True,out,err)  
