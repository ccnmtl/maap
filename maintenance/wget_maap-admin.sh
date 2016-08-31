#!/bin/bash

#
# dowload static snapshot of the MAAP site
#

ADMIN_DOMAIN="maap-admin.ccnmtl.columbia.edu"
ADMIN_URL="http://${ADMIN_DOMAIN}"

PUBLISH_URL="http://maap.columbia.edu"

DOWNLOAD_PATH="snapshots"
DOWNLOAD_DIR="current"

MAAP_ADMIN_PROD = "AIzaSyDQIQ9TQtS7wFLnIYgc6kTtnUtsfYH01zc" # v3
REPLACE_KEY=$MAAP_ADMIN_PROD

MAAP_COLUMBIA_EDU="AIzaSyDQIQ9TQtS7wFLnIYgc6kTtnUtsfYH01zc" # v3
PUBLISH_KEY=$MAAP_COLUMBIA_EDU

set -x 

mkdir -p $DOWNLOAD_PATH
cd $DOWNLOAD_PATH
mkdir $DOWNLOAD_DIR
cd $DOWNLOAD_DIR

# right now, login aint required.  If it were, we might need to load a cookie, since its not basic auth


# Options:
# no-host-directories we are creating the date directory ourselves
# recursive, levels get everything
# cut-dirs - dont recreate hierarchy (sb/common/eprep)
# page-requesites - retrieve all page reqs
# domains dont go offsite
# include/exclude directories try to only get the wakk pages
wget --quiet \
    --http-user="${HTTP_USER}" \
    --http-password="${HTTP_PASSWORD}" \
    --no-clobber \
    --no-host-directories  \
    --exclude-directories=/admin \
    --convert-links \
    --page-requisites \
    --html-extension \
    --page-requisites \
    --recursive --level=50 \
    --domains="${ADMIN_DOMAIN}" \
    $ADMIN_URL


EXTRA_PAGES="/search_results /contactconfirm /maap_library/images /maap_library/videos /maap_library/maps /mbl_index"

for page in $EXTRA_PAGES; do
    wget --quiet \
	--http-user="${HTTP_USER}	" \
	--http-password="${HTTP_PASSWORD}" \
	--no-clobber \
	--no-host-directories  \
	--exclude-directories=/admin \
	--convert-links \
	--page-requisites \
	--html-extension \
	--page-requisites \
	--recursive --level=50 \
	--domains="${ADMIN_DOMAIN}" \
	${ADMIN_URL}${page}
done;

# old method which copied static files from a special developers sandbox
## copy over (soon to be rsycn) the static directory explicitly

# deal w/ the static files that wget may have missed
# do a fresh git clone. Someday, maybe rolf will do all this, but this was all written pre-rolf
cp -r ../../maap/static/* static

# just make sure the admin pages are deleted - exclude-directories doesn't seem to work
rm -rf admin

# search/replace the google key, as well as any extraneous dev links
find . -type f | xargs perl -pi -e "s#${REPLACE_KEY}#${PUBLISH_KEY}#g; \
                                    s#${ADMIN_URL}#${PUBLISH_URL}#g"
