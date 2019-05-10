#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/share/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin"


echo "调用ansible的部署脚本"
ansible-playbook -i /etc/ansible/inventory/${environment} -f 1 /etc/ansible/playbook/deploy_jenkins_slave.yml -e "ansible_environment=${environment}" -e "src_dir=${WORKSPACE}"  -e "dest_dir=${dest_dir}" -e "host=${host}"