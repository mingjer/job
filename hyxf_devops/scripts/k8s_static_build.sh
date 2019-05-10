#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/local/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin"

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
cp /etc/ansible/k8s/dockerfile/common_static.df $WORKSPACE/${service_name}.df


echo ---构建镜像，并推送到docker仓库---
docker login -udevops -p $docker_password docker.51xf.cn
docker build -t docker.51xf.cn/51xf/${service_name}:${git_branch_ori} . -f $WORKSPACE/${service_name}.df
docker push docker.51xf.cn/51xf/${service_name}:${git_branch_ori}