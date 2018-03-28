# zookeeper

## 版本

zookeeper-3.4.6.tar.gz

## 安装部署方法

（1）解压缩

tar zxf zookeeper-3.4.6.tar.gz

（2）修改配置文件`zookeeper-3.4.6/conf/zoo.cfg`中对应条目。

示例：

    tickTime=2000 # zk时间单元。默认Session超时时间在2*tickTime ~ 20*tickTime，客户端超时时间不在这个范围，会被强制设置为最大或最小时间。
    initLimit=10
    syncLimit=5
    dataDir=/home/environment.common/zookeeper/data # 可自己指定
    dataLogDir=/home/environment.common/zookeeper/data/logs # 可自己指定
    clientPort=2181
    maxClientCnxns=100 # 根据实际修改每个客户端和单台zk机器的最大连接数
    server.1=qianjinding-dev1:2888:3888 # 3 节点
    server.2=qianjinding-dev3:2888:3888 # 不要忘记还要在dataDir下设置myid
    server.3=qianjinding-dev4:2888:3888 # 

（3）分别在qianjinding-dev1、qianjinding-dev3、qianjinding-dev4的dataDir下新建文件myid，分别填入1、2、3

示例：

    qianjinding-dev1$ cat myid
    1

（3）服务启停

`zookeeper-3.4.6/bin/zkServer.sh`加参数，如start、stop。
