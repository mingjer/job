#!/bin/bash

foreachd(){
        for file in $1/*
        do
                if [ -d $file ];
                then
                        echo "$file is dir"
                        foreachd $file
                elif [ -f $file ];
                then
                        echo "$file is file"
                        cp $file /logs/ && find $file -mtime +0 -name "*.*" | xargs rm -f
                fi
        done
}


if [[ "x$1" == 'x' ]];
then
        foreachd "."
else
        foreachd "$1"
fi