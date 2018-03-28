# RedisCluster

## 官方

一、目前官方稳定版为2.8和3.0。

2.8+**仅**支持高可用，不支持分片，依赖[Sentinel 2](http://redis.io/topics/sentinel)。客户端需适配，如java使用Jedis支持Sentinel。业界也有使用keeplived（vip）集成的方式。

3.0+支持Cluster，客户端需适配。


## 第三方

一、[NetFlix-Dynomite](http://techblog.netflix.com/2014/11/introducing-dynomite.html)


二、[Twitter-Twemproxy](https://github.com/twitter/twemproxy)


三、[Wandoulabs-Codis](https://github.com/wandoulabs/codis)
