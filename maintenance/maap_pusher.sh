#!/bin/bash

# we push from kodos
# run maintenance/wget_maap-admin.sh first
# this takes a wget snapshot of maap-admin.ccnmtl and puts it in sandboxes/common/maap/snapshots/current
# we rsycn over our sshfs mount from here to the prod deployment dir

set -x

SRC_DIR=/usr/local/share/sandboxes/common/maap/snapshots/current/
#DEST_DIR=/mnt/cunix/www-data/ccnmtl/projects/maap
DEST_DIR=tlcreg@cunix.cc.columbia.edu:/www/data/ccnmtl/projects/maap

# -rlptgoD is equivalent to -a, but we don't want to preserve perms or owners or groups
# use tee to echo the message, as well as append it to the log
rsync -rltD -z -v  $SRC_DIR $DEST_DIR
