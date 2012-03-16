#!/bin/bash
# getter_better script from gumstix
# what a great idea...
#SITE="http://astlinuxfiles.s3.amazonaws.com"
SITE="files.astlinux.org"

WGET_ARGS="--passive-ftp --timeout=30 -c -t 2"

wget $WGET_ARGS $@ || (
	echo Retrying from astlinux alternate site...
	index=$#-1
	# Copy all params into an array
	for (( i=0; $?==0; i++ ));do a[$i]=$1; shift; done
	# Chop all but filename from last param and prepend out URL
	a[$index]=${a[index]/*\//http:\/\/$SITE/}
	# Now wget that from our server
	wget $WGET_ARGS ${a[@]}
)


for i in $@; do
  URL="$i"
done

FILE=$(basename $URL)

wget $WGET_ARGS -nv -P dl "$SITE/$FILE.sha1"

if sha1sum -c --status "dl/$FILE.sha1"; then
  echo "$FILE verified"
  exit 0
elif grep -q "^$FILE" "toolchain/file_exclude"; then
  echo "Skipping file verification abort"
  exit 0
else
  echo "$FILE failed verification - exiting"
  exit 1
fi

