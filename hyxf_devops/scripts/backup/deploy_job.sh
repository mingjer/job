#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/share/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin"

echo "maven开始编译打包"
mvn clean package -P${environment} -U -Dmaven.test.skip=true -Dmaven.repo.local=$JENKINS_HOME/.m2/${environment}/ || exit 1


echo ---获取war文件的完整路径---
app_file=$(find $WORKSPACE/ -name "*.war")
echo $app_file

echo ---本次构建的环境---
echo ${environment}

echo ---本次构建的分支---
echo ${GIT_BRANCH}

echo ---本次构建的项目---
echo ${service_name}


echo ---该项目监听的端口---
echo ${jetty_port}



echo "调用ansible的部署脚本"
ansible-playbook -i /etc/ansible/inventory/${environment} -f 1 /etc/ansible/playbook/core/core-job-admin-common.yml -e "ansible_environment=${environment}" -e "JENKINS_WORKSPACE=${WORKSPACE}" -e "host=${host}" -e "service_name=${service_name}" -e     "jetty_name=${jetty_name}" -e "jetty_port=${jetty_port}"  -e "app_file=${app_file}"