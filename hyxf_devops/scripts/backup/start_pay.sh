#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
export PATH="$PATH:$JAVA_HOME/bin"

#获取当前目录名，即为appname
current_dir=`echo $(dirname $(readlink -f "$0"))`
jar_name=`echo $current_dir | awk -F/ '{print $NF}'`


#筛选是否含有含有相关进程，如果有，执行结果为0，如果没有，则为其他值
jps | grep $jar_name.jar &> /dev/null
if [ $? -eq 0 ];then
    sh $current_dir/stop.sh
    sh $current_dir/start.sh
else
java -jar \
    -Xms1024m \
    -Xmx1024m \
    -XX:MetaspaceSize=128m \
    -XX:MaxMetaspaceSize=128m \
    -Xmn256m \
    -XX:SurvivorRatio=8 \
    -XX:+UseConcMarkSweepGC \
    -XX:+UseCMSCompactAtFullCollection \
    -XX:CMSMaxAbortablePrecleanTime=5000 \
    -XX:+CMSClassUnloadingEnabled \
    -XX:CMSInitiatingOccupancyFraction=80 \
    -XX:CMSFullGCsBeforeCompaction=5 \
    -XX:+DisableExplicitGC \
    -XX:+DisableExplicitGC \
    -verbose:gc \
    -Xloggc:/opt/soft/oom/gc.log \
    -XX:+PrintGCDetails \
    -XX:+PrintGCDateStamps \
    -XX:+UseCompressedOops \
    -Djava.awt.headless=true \
    -Dsun.net.client.defaultConnectTimeout=10000 \
    -Dsun.net.client.defaultReadTimeout=30000 \
    -Dfile.encoding=UTF-8 \
    -XX:+TieredCompilation \
    -XX:CICompilerCount=4 \
    -XX:+HeapDumpOnOutOfMemoryError \
    -XX:HeapDumpPath=/opt/soft/oom/ \
    /opt/soft/jar/$jar_name/$jar_name.jar >/dev/null 2>&1 &
	
sleep 10	

jps | grep $jar_name.jar &> /dev/null
[ $? -eq 0 ] && echo "$jar_name 已经启动" || echo "$jar_name 启动失败"
fi