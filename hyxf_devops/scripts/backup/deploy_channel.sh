#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/share/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin"

cd $WORKSPACE/hy-$channel_name-$task_name/
rm -rf target
echo "maven开始编译打包"
mvn clean package -P${environment} -U -Dmaven.test.skip=true -Dmaven.repo.local=$JENKINS_HOME/.m2/${environment}/ || exit 1

echo "获取构建产物"

echo ---获取war文件的完整路径---
war_file=$(find $WORKSPACE/hy-$channel_name-$task_name/ -name "*.war")
echo $war_file


if [ "$task_name"x = "webapp"x ]; then
	echo ---拼接app_name名称---
	app_name=tomcat$(echo $channel_name | tr '[a-z]' '[A-Z]')
	echo $app_name


	echo "调用ansible的部署脚本"
	ansible-playbook -i /etc/ansible/inventory/${environment} -f 1 /etc/ansible/playbook/core/channel-webapp-common.yml -e "ansible_environment=${environment}" -e "JENKINS_WORKSPACE=${WORKSPACE}" -e "host=${host}" -e "service_name=${channel_name}" -e "jetty_name=${app_name}" -e "jetty_port=${jetty_port}" -e "app_file=${war_file}"

else
	echo ---拼接app_name名称---
	app_name=tomcat$(echo $channel_name | tr '[a-z]' '[A-Z]')_$(echo $task_name | tr '[a-z]' '[A-Z]')
	echo $app_name

	echo "调用ansible的部署脚本"
	ansible-playbook -i /etc/ansible/inventory/${environment} -f 1 /etc/ansible/playbook/core/channel-schedule-common.yml -e "ansible_environment=${environment}" -e "JENKINS_WORKSPACE=${WORKSPACE}" -e "host=${host}" -e "service_name=${channel_name}" -e "jetty_name=${app_name}" -e "jetty_port=${jetty_port}" -e "app_file=${war_file}"
fi
