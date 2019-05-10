#!/bin/sh

#获取当前目录名，即为appname
current_dir=`echo $(dirname $(readlink -f "$0"))`
jar_name=`echo $current_dir | awk -F/ '{print $NF}'`

echo $jar_name
#筛选是否含有含有相关进程，如果有，执行结果为0，如果没有，则为其他值
jps -ml | grep $jar_name.jar &> /dev/null
if [ $? -eq 0 ];then
    sh $current_dir/stop.sh
    sh $current_dir/start.sh
else
nohup java -jar -Xms500M -Xmx500M $jar_name.jar --spring.profiles.active=$1 > nohup.out &

sleep 15

jps -ml | grep $jar_name.jar &> /dev/null
[ $? -eq 0 ] && echo "$jar_name 已经启动" || echo "$jar_name 启动失败"
fi

