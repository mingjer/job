#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/share/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin"

echo ---进入到打包目录---
cd $WORKSPACE/$jar_name/

echo ---maven开始编译打包---
mvn clean package -U -Dmaven.test.skip=true -Dmaven.repo.local=$JENKINS_HOME/.m2/${environment}/ || exit 1

echo ---跳出到打包目录---
cd $WORKSPACE/

echo ---获取构建后，jar包文件的完整路径，根据jar包大小进行判断---
jar_file_old=$(find $WORKSPACE -name "*$jar_name*.jar"|xargs du -shm |sort -nr |head -n 1 | awk '{print $2}')
echo $jar_file_old


echo ---处理jar包，进行重命名，并获取jar包文件的实际路径---
yes 2>/dev/null |cp -r $jar_file_old $WORKSPACE/$jar_name.jar
jar_file=$(ls $WORKSPACE/$jar_name.jar)
echo $jar_file


echo ---本次构建的环境---
echo ${envs}

echo ---本次构建的分支---
echo ${GIT_BRANCH}

echo ---本次构建的项目---
echo ${jar_name}

echo ---本次构建的版本号---
git_commit_tmp=${GIT_COMMIT}
echo $git_commit_tmp

git_commit_ori=${git_commit_tmp:0:8}
echo $git_commit_ori

echo ---该项目监听的端口---
echo ${jar_port}


ansible-playbook  -i /etc/ansible/inventory/$envs /etc/ansible/jar-deploy.yml -e "host=$host" -e "src_dir=${jar_file}" -e "jar_port=$jar_port" -e "jar_name=$jar_name" -e "envs=$envs"