#!/bin/sh

#获取当前目录名，即为appname
current_dir=`echo $(dirname $(readlink -f "$0"))`
jar_name=`echo $current_dir | awk -F/ '{print $NF}'`

pidarray=`jps -ml | grep $jar_name.jar | awk -F' ' '{print $1}'`
for pid in $pidarray; do
	kill -9 $pid
	echo "$jar_name 已关闭"
done
if [ -z $pidarray ];then
	echo "$jar_name pid 未找到"
fi
