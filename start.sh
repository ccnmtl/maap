#!/bin/bash
cd $1
export PYTHON_EGG_CACHE=/var/www/maap/.python-eggs
source working-env/bin/activate
exec ./start-maap.py $2 

