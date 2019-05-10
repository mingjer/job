#!/bin/sh
SHELL=/bin/sh
JAVA_HOME=/opt/soft/jdk
M2_HOME=/usr/local/maven
export PATH="$PATH:$JAVA_HOME/bin:$M2_HOME/bin:/opt/kube/bin"

echo ---本次构建的环境---
echo ${environment}


echo ---创建相关应目录---
ssh 192.192.0.79 "mkdir -p /k8s/${environment}/zk/{zk0,zk1,zk2}"
ssh 192.192.0.79 "mkdir -p /k8s/${environment}/mysql/mysql0"
ssh 192.192.0.79 "mkdir -p /k8s/${environment}/mongo/cluster/mongo0"
ssh 192.192.0.79 "mkdir -p /k8s/${environment}/rocketmq/broker/0/"
ssh 192.192.0.79 "mkdir -p /k8s/${environment}/rocketmq/namesrv/0/"
ssh 192.192.0.79 "mkdir -p /k8s/${environment}/redis/sentinel/{redis0,redis1}"
ssh 192.192.0.79 "mkdir -p /k8s/${environment}/redis/cluster/{redis0,redis1}"
ssh 192.192.0.79 "mkdir -p /k8s/${environment}/cert/{psbc,second,abc,baofoo,baofooprotocol,baofootransfer,cibhsf,cmbc,jd,xinyan}"
ssh 192.192.0.79 "chmod -R 755 /k8s/${environment}"

echo ---创建namespace---
kubectl create ns ${environment}


echo ---部署中间件---
sed -i "s#k8s-dev1#${environment}#g" $WORKSPACE/k8s/statefulset/nfs/*.yml
sed -i "s#51xf_number#${BUILD_NUMBER}#g" $WORKSPACE/k8s/statefulset/nfs/*.yml
kubectl apply -f $WORKSPACE/k8s/statefulset/nfs/

echo ---等待中间启动---
sleep 120