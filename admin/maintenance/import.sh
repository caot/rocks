#!/bin/bash
#
# Clementi
# 
# this script import a CVS inside a git starting from data1/date2
#
# cvsimport does not handle well importing from a given date
# for this reason I wrote this script
#


# date2 should be 1 minute after date1
date1='2008/04/30 00:00:00'
date2='2008/04/30 00:01:00'

# Base path where the script is
ScriptDir=`dirname $0`


if [ ! "$1" ]; then 
	echo You must pass the name of the repo
	exit -1
fi

export CVSROOT=clem@fyp.rocksclusters.org:/home/cvs/CVSROOT

### cvs import from a date proper procedure
cvs co -D "$date1" rocks/src/roll/$1
mv rocks/src/roll/$1 .
rm -rf rocks/
cd $1/
cvs update -dP
cvs status Makefile 

#clean the CVS 
for i in `find . -name CVS`;do rm -rf $i;done

#init git
git init
#git status
git add *
git commit -m "First commit of the repo: pruned at ROCKS_5_0"  --date "$date1"

#now do the incremental import
git cvsimport -o master -A $ScriptDir/Author.txt -p -d,"$date2" rocks/src/roll/$1


