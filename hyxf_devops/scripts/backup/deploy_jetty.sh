#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/share/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin"

echo "maven开始编译打包"
mvn clean package -P${environment} -B -e -U -Dmaven.test.skip=true -Dmaven.repo.local=$JENKINS_HOME/.m2/${environment}/ || exit 1


echo ---获取war文件的完整路径---
app_file=$(find $WORKSPACE/ -name "*.war")
echo $app_file

echo ---拼接app_name名称---
app_name=jetty$(echo $service_name | tr '[a-z]' '[A-Z]')
echo $app_name

echo ---本次构建的环境---
echo ${environment}

echo ---本次构建的分支---
echo ${GIT_BRANCH}

echo ---本次构建的项目---
echo ${service_name}

echo ---本次生成的war包名称---
app_file_name=$(basename $app_file)
echo $app_file_name

echo ---该项目监听的端口---
echo ${jetty_port}



echo "调用ansible的部署脚本"
ansible-playbook -i /etc/ansible/inventory/${environment} -f 1 /etc/ansible/playbook/core/core-common-jetty.yml -e "ansible_environment=${environment}" -e "JENKINS_WORKSPACE=${WORKSPACE}" -e "host=${host}" -e "service_name=${service_name}" -e "jetty_name=${app_name}" -e "jetty_port=${jetty_port}"  -e "app_file=${app_file}"