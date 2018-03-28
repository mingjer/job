# 公共组件信息

## 1、zookeeper 3 节点集群。

**线下环境**

autoconfig中配置样例：`zookeeper://10.1.1.182:2181?backup=10.1.1.185:2181,10.1.1.186:2181`。

**线上环境**

autoconfig中配置样例：`zookeeper://10.171.240.41:2181?backup=10.252.143.141:2181,10.171.243.19:2181`。

## 2、activemq 3 节点集群。

**线下环境**

> [devamq url](http://devamq.htrader.cn/admin/)

autoconfig中配置样例：`failover:(tcp://10.1.1.127:61616,tcp://10.1.1.128:61616,tcp://10.1.1.129:61616)`。

**线上环境**

> [amq](http://amq.htrader.cn/admin/)

autoconfig中配置样例：`failover:(tcp://10.171.240.41:61616,tcp://10.252.143.141:61616,tcp://10.171.243.19:61616)`。

## 2、rabbitmq 2 节点集群。

调用地址：100.114.48.228

**线下环境**

> [devrmq url](http://devrmq.htrader.cn)

集群列表信息：`10.1.1.182、10.1.1.62`。

**线上环境**

> [rmq](http://rmq.htrader.cn)

集群列表信息：`10.47.110.175、10.24.36.74`。

## 3、mongodb 3 节点集群。

nodejs连接mongodb集群，连接方式可参考[node-mongodb-replicasets文档](https://github.com/christkv/node-mongodb-native/blob/master/docs/replicaset.md)。

**线下环境**

> [devmongo url](http://devmongo.htrader.cn/_replSet)

集群列表信息：`10.1.1.184:27017,10.1.1.185:27017,10.1.1.186:27017`，replica set name 是 dev。

**预发和线上环境**

> [mongo](http://mongo.htrader.cn/_replSet)

集群列表信息：`10.171.250.51:27017,10.168.23.115:27017,10.252.89.44:27017`，replica set name 是 online。

## 4、MySql。

**线上预发环境**

仟金顶&卓筑&报表：rm-bp11g52wa9mxo81xk.mysql.rds.aliyuncs.com

**线上生产环境**

仟金顶：rdsremvbzuyvvia.mysql.rds.aliyuncs.com

卓筑：rds40wvp558y8q12u0qz.mysql.rds.aliyuncs.com

报表：rm-bp17h7li0k0o939ip.mysql.rds.aliyuncs.com

**数据查询**

> 注意，数据库中的敏感字段进行了加密，查询后，可将相应加密字段发送给运维人员进行解码。

可通过[跳板机](https://jump.htrader.cn/)登录shterm或pre的机器后，分别执行如下命令：qjdsql、zzwsql、bisql、presql，密码请咨询运维人员。

## 5、redis。

**预发环境**

100.114.196.132

> 实际部署在pre5

**线上生产环境**

100.114.196.61

> 实际部署在redis1

## 6、刷ams缓存

**预发环境**

http://100.114.70.173/ams/front/init/redis

> 实际对应http://10.175.192.189:8085/ams/front/init/redis

**线上生产环境**

http://100.114.70.172/ams/front/init/redis

> 实际对应http://10.51.3.178:8080/ams/front/init/redis

## 7、ldap

**线下环境**

10.1.1.63 **通常**ou为People，账号同步仟金顶钉钉账号，密码统一为123456，无需修改；暂备vPeople。

> 实际部署在qianjinding-test2

**线上环境**

10.251.253.74 **生产**ou为People，账号同步仟金顶钉钉账号，密码需用户自助修改；预发ou为vPeople。

> 实际部署在jenkins

## 8、前、后nginx。

前后nginx架构流量导向图[请参考这里](http://wiki.htrader.cn/environment.common/Nginx/Nginx-Arch)。

**线下环境**

前nginx在qianjinding-dev0上，后nginx在qianjinding-dev2上，更改配置可联系运维（ops@htrader.cn）协助处理。特殊情况可`systemctl stop puppet.service`后，自己**临时**更改配置。

**预发环境**

前nginx在pre0、pre10上，后nginx在100.114.194.45（pre1、pre5）上，更改配置可联系运维（ops@htrader.cn）协助处理。

**线上生产环境**

前nginx在nginx2、nginx4上，后nginx在100.114.196.171（nginx3、nginx5）上，更改配置可联系运维（ops@htrader.cn）协助处理。

**【注意】**，需要查询主机（如nginx）对应的ip信息，请访问[线上服务器列表信息](http://wiki.htrader.cn/MachineList/OnlineMachineList)。
