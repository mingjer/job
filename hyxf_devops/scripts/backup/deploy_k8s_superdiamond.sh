#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/share/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin"

echo ---本次构建的环境---
echo ${environment}


echo ---处理k8s的namespace脚本---
cp /etc/ansible/k8s/create_namespace.yml $WORKSPACE/namespace_${environment}.yml

sed -i "s/51xf_namespace/${environment}/g" $WORKSPACE/namespace_${environment}.yml

namespace_yml=$(find $WORKSPACE/ -name "namespace_${environment}.yml" -maxdepth 1)
echo ${namespace_yml}

echo ---调用k8s创建namespace脚本---
ansible-playbook -i /etc/ansible/inventory/${environment} -f 1 /etc/ansible/k8s/deploy_namespace.yml -e "ansible_environment=${environment}" -e "host=${host}" -e "namespace_yml=${namespace_yml}" -vvv


echo ---处理k8s的部署脚本---
cp /etc/ansible/k8s/common_superdiamond.yml $WORKSPACE/${service_name}_${environment}.yml

#sed -i "s/51xf_app/${service_name}/g" $WORKSPACE/${service_name}_${environment}.yml
#sed -i "s/51xf_version/${git_commit_ori}/g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s/51xf_namespace/${environment}/g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s/51xf_environment/${environment}/g" $WORKSPACE/${service_name}_${environment}.yml
#sed -i "s/pub-port/${pub-port}/g" $WORKSPACE/${service_name}_${environment}.yml
#sed -i "s/private-port/${private-port}/g" $WORKSPACE/${service_name}_${environment}.yml
#sed -i "s#cluster_ip#${cluster_ip}#g" $WORKSPACE/${service_name}_${environment}.yml
#sed -i "s#rc_no#${rc_no}#g" $WORKSPACE/${service_name}_${environment}.yml

k8s_yml=$(find $WORKSPACE/ -name "${service_name}_${environment}.yml")
echo ${k8s_yml}


echo ---调用k8s部署脚本---
ansible-playbook -i /etc/ansible/inventory/${environment} -f 1 /etc/ansible/k8s/deploy_k8s.yml -e "ansible_environment=${environment}" -e "host=${host}" -e "service_name=${service_name}" -e "k8s_yml=${k8s_yml}" -vvv