#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/share/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin"

cp $WORKSPACE/ansible/scripts/${service_name}*.sh $WORKSPACE/
rm -fr $WORKSPACE/ansible


echo "maven开始编译打包"

cd $WORKSPACE/hsjry-easyflow-facade-pojo
mvn clean install -U -Dmaven.test.skip=true -Dmaven.repo.local=$JENKINS_HOME/.m2/${environment}/ || exit 1

cd $WORKSPACE/hsjry-easyflow-facade
mvn clean install -U -Dmaven.test.skip=true -Dmaven.repo.local=$JENKINS_HOME/.m2/${environment}/ || exit 1

cd $WORKSPACE/hsjry-easyflow-dpk
mvn clean install -P${environment} -U -Dmaven.test.skip=true -Dmaven.repo.local=$JENKINS_HOME/.m2/${environment}/ || exit 1


echo "获取构建产物"

echo ---获取zip文件的完整路径---
zip_file=$(find $WORKSPACE/hsjry-${service_name}/target/ -name "*.zip")
echo $zip_file


echo ---获取start_shell文件的完整路径---
start_shell=$(find $WORKSPACE/hsjry-${service_name} -name "start.sh")
echo $start_shell


echo ---获取restart_shell文件的完整路径---
restart_shell=$(find $WORKSPACE/hsjry-${service_name} -name "restart.sh")
echo $restart_shell


echo ---获取run_shell文件的完整路径---
run_shell=$(find $WORKSPACE/hsjry-${service_name} -name "easyFlowRun.sh")
echo $run_shell


echo "调用ansible的部署脚本"
ansible-playbook -i /etc/ansible/inventory/${environment} -f 1 /etc/ansible/playbook/core/core-dpkeasyflow.yml -e "ansible_environment=${environment}" -e "JENKINS_WORKSPACE=${WORKSPACE}" -e "host=${host}" -e "service_name=${service_name}" -e "jetty_name=${app_name}" -e "jetty_port=${jetty_port}" -e "zip_file=${zip_file}" -e "start_shell=${start_shell}" -e "restart_shell=${restart_shell}" -e "run_shell=${run_shell}"














