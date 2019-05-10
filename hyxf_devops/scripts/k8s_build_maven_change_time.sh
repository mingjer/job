#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/local/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin:/opt/kube/bin"

echo ---maven开始编译打包---
mvn clean package -U -Dmaven.test.skip=true -Dmaven.repo.local=$JENKINS_HOME/.m2/${environment}/ || exit 1

echo ---获取构建后，jar包文件的完整路径，根据jar包大小进行判断---
jar_file_old=$(find $WORKSPACE -name "*$service_name*.jar"|xargs du -shm |sort -nr |head -n 1 | awk '{print $2}')
echo $jar_file_old



echo ---处理jar包，进行重命名，并获取jar包文件的实际路径---
yes 2>/dev/null |cp -r $jar_file_old $WORKSPACE/$service_name.jar
jar_file=$(ls $WORKSPACE/$service_name.jar)
echo $jar_file


echo ---本次构建的环境---
echo ${environment}

echo ---本次构建的分支---
echo ${GIT_BRANCH}

echo ---本次构建的项目---
echo ${service_name}

echo ---本次构建的版本号---
git_branch_tmp=${GIT_BRANCH}
echo $git_branch_tmp

git_branch_ori=${git_branch_tmp##*/}
echo $git_branch_ori

git_branch_ori=${git_branch_tmp##*/}
echo $git_branch_ori >> tmp.txt

echo ---处理dockerfile文件---
cp /etc/ansible/k8s/dockerfile/common_springboot_changetime.df $WORKSPACE/${service_name}.df
sed -i "s#51xf_war#${service_name}#g" $WORKSPACE/${service_name}.df


echo ---构建镜像，并推送到docker仓库---
docker login -udevops -p $docker_password docker.51xf.cn \
&& docker build -t docker.51xf.cn/51xf/${service_name}:${git_branch_ori} . -f $WORKSPACE/${service_name}.df \
&& docker push docker.51xf.cn/51xf/${service_name}:${git_branch_ori}