#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/local/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin"

echo ---处理k8s的部署脚本---
cp /etc/ansible/k8s/common_smgpolicy.yml $WORKSPACE/${service_name}_${environment}.yml

echo --获取构建次数---
build_no={BUILD_NUMBER}

echo build_no: $build_no

sed -i "s/51xf_app/${service_name}/g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s#51xf_version#${version}#g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s/51xf_namespace/${environment}/g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s/51xf_environment/${environment}/g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s#51xf_number#${BUILD_NUMBER}#g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s#rc_no#${rc_no}#g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s#smg_policy_file#${smg_policy_file}#g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s#branch#${branch}#g" $WORKSPACE/${service_name}_${environment}.yml

#sed -i "s/pub-port/${pub-port}/g" $WORKSPACE/${service_name}_${environment}.yml
#sed -i "s/private-port/${private-port}/g" $WORKSPACE/${service_name}_${environment}.yml
#sed -i "s#cluster_ip#${cluster_ip}#g" $WORKSPACE/${service_name}_${environment}.yml


k8s_yml=$(find $WORKSPACE/ -name "${service_name}_${environment}.yml")
echo ${k8s_yml}


echo ---调用k8s部署脚本---
ansible-playbook -i /etc/ansible/inventory/k8s-node -f 1 /etc/ansible/k8s/deploy_k8s.yml -e "ansible_environment=${environment}" -e "host=${host}" -e "service_name=${service_name}" -e "k8s_yml=${k8s_yml}" -vvv