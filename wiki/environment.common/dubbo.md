# dubbo-monitor

## 版本

dubbo-monitor-simple-2.5.4-SNAPSHOT-assembly.tar.gz

## 安装部署方法

（1）解压缩

tar zxf dubbo-monitor-simple-2.5.4-SNAPSHOT-assembly.tar.gz

（2）修改配置文件`dubbo-monitor-simple-2.5.4-SNAPSHOT/conf/dubbo.properties`中对应条目。

示例：

    dubbo.container=log4j,spring,registry,jetty
    dubbo.application.name=simple-monitor
    dubbo.application.owner=
    dubbo.registry.address=zookeeper://10.1.1.182:2181?backup=10.1.1.182:2182,10.1.1.182:2183 ## zookeeper3节点注册
    dubbo.protocol.host=10.1.1.62  ## 本机监听地址
    dubbo.protocol.port=17070      ## 监听端口
    dubbo.jetty.port=18080         ## jetty端口
    dubbo.jetty.directory=../monitor  ## ../monitor:monitor和dubbo在同一父目录下
    dubbo.charts.directory=${dubbo.jetty.directory}/charts
    dubbo.statistics.directory=../monitor/statistics
    dubbo.log4j.file=logs/dubbo-monitor-simple.log
    dubbo.log4j.level=WARN
    dubbo.registry.file=/home/qianjinding/.dubbo/dubbo-registry-monitor.cache
    ## Dubbo会根据注册中心生成一个缓存文件~/.dubbo/dubbo-registry-*.*.*.*.cache，星号表示注册中心的IP地址。
    ## 当同一台机器同时启动多个进程，多个进程争夺此文件写入权限，日志报错，解决需指定缓存文件，dubbo-monitor可在配置文件中指定。
    #dubbo.service.min.thread.pool.size=100
    #dubbo.service.max.thread.pool.size=100

（3）服务启停

`dubbo-monitor-simple-2.5.4-SNAPSHOT/bin`下启停脚本。
