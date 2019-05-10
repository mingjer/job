#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/share/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin"

#cd $WORKSPACE/hsjry-${service_name}-deploy/

echo ---maven开始编译打包---
mvn clean package -P${environment} -U -Dmaven.test.skip=true -Dmaven.repo.local=$JENKINS_HOME/.m2/${environment}/ || exit 1

echo ---获取构建后，war包文件的完整路径---
app_file_tmp=$(find $WORKSPACE/ -name "*.war")
echo $app_file_tmp

echo ---处理war包文件---
yes|cp $app_file_tmp $WORKSPACE/${service_name}.war

echo ---获取处理后，war包文件的实际路径---
app_file=$(find $WORKSPACE/ -name "${service_name}.war" -maxdepth 1)
echo $app_file

echo ---本次构建的环境---
echo ${environment}

echo ---本次构建的分支---
echo ${GIT_BRANCH}

echo ---本次构建的项目---
echo ${service_name}

echo ---本次构建的版本号---
51xf_version=${GIT_COMMIT}
echo $51xf_version

echo ---该项目监听的端口---
echo ${jetty_port}


echo ---处理dockerfile文件---
cp /etc/ansible/k8s/dockerfile/common_jetty.df $WORKSPACE/${service_name}.df
sed -i "s#51xf_war#${service_name}#g" $WORKSPACE/${service_name}.df


echo ---构建镜像，并推送到docker仓库---
docker login -udevops -p $docker_password docker.51xf.cn
docker build -t docker.51xf.cn/51xf/${service_name}:${GIT_COMMIT} . -f $WORKSPACE/${service_name}.df
docker push docker.51xf.cn/51xf/${service_name}:${GIT_COMMIT} || exit 1


echo ---处理k8s的namespace脚本---
cp /etc/ansible/k8s/create_namespace.yml $WORKSPACE/namespace_${environment}.yml

sed -i "s/51xf_namespace/${environment}/g" $WORKSPACE/namespace_${environment}.yml

namespace_yml=$(find $WORKSPACE/ -name "namespace_${environment}.yml" -maxdepth 1)
echo ${namespace_yml}

echo ---调用k8s创建namespace脚本---
ansible-playbook -i /etc/ansible/inventory/${environment} -f 1 /etc/ansible/k8s/deploy_namespace.yml -e "ansible_environment=${environment}" -e "host=${host}" -e "namespace_yml=${namespace_yml}" -vvv


echo ---处理k8s的部署脚本---
cp /etc/ansible/k8s/common.yml $WORKSPACE/${service_name}_${environment}.yml

sed -i "s/51xf_app/${service_name}/g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s/51xf_version/${GIT_COMMIT}/g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s/51xf_namespace/${environment}/g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s/51xf_environment/${environment}/g" $WORKSPACE/${service_name}_${environment}.yml
#sed -i "s/pub-port/${pub-port}/g" $WORKSPACE/${service_name}_${environment}.yml
#sed -i "s/private-port/${private-port}/g" $WORKSPACE/${service_name}_${environment}.yml
#sed -i "s#cluster_ip#${cluster_ip}#g" $WORKSPACE/${service_name}_${environment}.yml
sed -i "s#rc_no#${rc_no}#g" $WORKSPACE/${service_name}_${environment}.yml

k8s_yml=$(find $WORKSPACE/ -name "${service_name}_${environment}.yml")
echo ${k8s_yml}


echo ---调用k8s部署脚本---
ansible-playbook -i /etc/ansible/inventory/${environment} -f 1 /etc/ansible/k8s/deploy_k8s.yml -e "ansible_environment=${environment}" -e "host=${host}" -e "service_name=${service_name}" -e "k8s_yml=${k8s_yml}" -vvv