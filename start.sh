#!/bin/bash
cd $1
source ve/bin/activate
exec python start-maap.py $2

