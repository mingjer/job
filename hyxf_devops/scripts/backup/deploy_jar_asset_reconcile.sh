#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/share/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin"

echo "maven开始编译打包"
mvn clean package -P${environment} -U -Dmaven.test.skip=true -Dmaven.repo.local=$JENKINS_HOME/.m2/${environment}/ || exit 1


echo ---获取jar文件的完整路径---
jar_file_old=$(find $WORKSPACE -name "*$jar_name*.jar"|xargs du -shm |sort -nr |head -n 1 | awk '{print $2}')
echo $jar_file_old


echo ---处理jar包，并进行重命名---
yes 2>/dev/null |mv $jar_file_old $WORKSPACE/$jar_name.jar
jar_file=$(ls $WORKSPACE/$jar_name.jar)
echo $jar_file


echo ---获取启动脚本的完整路径---
/usr/bin/cp /etc/ansible/scripts/start.sh $WORKSPACE/start.sh
start_bash=$( ls $WORKSPACE/start.sh )
echo $start_bash


echo ---获取启动脚本的名称---
start_bash_name=$( basename $start_bash)
echo $start_bash_name


echo ---获取关闭脚本的完整路径---
/usr/bin/cp /etc/ansible/scripts/stop.sh $WORKSPACE/stop.sh
stop_bash=$( ls $WORKSPACE/stop.sh )
echo $stop_bash


echo ---获取关闭脚本的名称---
stop_bash_name=$( basename $stop_bash)
echo $stop_bash_name



echo "调用ansible的部署脚本"
ansible-playbook -i /etc/ansible/inventory/${environment} -f 1 /etc/ansible/playbook/core/core-common-jar.yml -e "jar_file=${jar_file}" -e "jar_file_name=${jar_file_name}" -e "jar_name=${jar_name}" -e "jar_port=${jar_port}" -e "host=${host}" -e "start_bash=${start_bash}" -e "stop_bash=${stop_bash}" -e "ansible_environment=${environment}"
