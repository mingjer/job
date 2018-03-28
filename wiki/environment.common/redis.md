# Redis Server

## 版本

2.8.x

## 安装部署

1.安装：

    $ yum install redis

2.修改配置文件

    $ vi /etc/redis.conf
    daemonize yes
    bind 0.0.0.0

3.设置开机自启动

    $ sudo systemctl  enable  redis.service

4.启动

    $ sudo systemctl  start  redis.service

5.查看服务

    $ ps aux | grep redis
    /usr/bin/redis-server 0.0.0.0:6379

6.redis刷新缓存

    $ redis-cli
    > select 1
    > flushdb    //刷新指定库的缓存
    $ curl http://ip:port/ams/front/init/redis   //专门用来刷新ams的redis缓存
