#!/bin/bash
export PYTHON_EGG_CACHE=/var/www/maap/.python-eggs
source working-env/bin/activate
tg-admin sql create
