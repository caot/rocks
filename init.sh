#!/bin/bash
#
# clone all the subrepo
#

if [ "$1" == "--source" ]; then 
    SOURCE=true
    baseURL="http://github.com/rocksclusters"
fi


SubModule=`cat .gitignore`

remote=`git remote -v|awk '{print $2}'|head -n 1`
baseRemote=`dirname $remote`

start_time=$(date +%s)

pushd src/roll
for i in $SubModule;
do 
    modName=`basename $i`
    if [ "$SOURCE" ]; then 
        wget -O $modName.tar.gz $baseURL/$modName/archive/master.tar.gz
	tar -xvzf $modName.tar.gz
	mv $modName-master $modName
	rm $modName.tar.gz
    else
        echo "  Cloning $baseRemote/$modName.git repository" 
        git clone $baseRemote/$modName.git $modName
    fi
done
popd

finish_time=$(date +%s)
echo "Time duration: $((finish_time - start_time)) secs."

