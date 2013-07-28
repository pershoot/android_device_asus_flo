#!/bin/sh

BASE=../../../vendor/asus/flo/proprietary
rm -rf $BASE/*

for FILE in `cat proprietary-blobs.txt | grep -Ev '(^#.*$)|(^$)' | sed s:"/system/"::g`; do
    DIR=`dirname $FILE`
    if [ ! -d $BASE/$DIR ]; then
        mkdir -p $BASE/$DIR
    fi
    adb pull /system/$FILE $BASE/$FILE
done

./setup-makefiles.sh
