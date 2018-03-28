# 邮件发信依赖

机器均为内网，邮件依赖有外网机器[rinetd](http://www.boutell.com/rinetd/)进行tcp转发。目前使用负载均衡，IP为100.98.113.250。

    $ cat /etc/rinetd.conf
    allow 10.*.*.*
    10.175.196.119 80  yunpian.com 80  ## yunpian内网转发
    10.175.196.119 443 api.weixin.qq.com 443  ## weixin内网转发
    10.175.196.119 25  smtp.mxhichina.com 25  ## 邮件内网转发，被artemis等依赖
    10.175.196.119 465 smtp.mxhichina.com 465

> kill -1 PID可重载配置，但经实测，Dns解析更新后，需重启生效。

[pms](http://pms.htrader.cn/zentaopms/www/)和[仟金顶wiki](http://wiki.htrader.cn/)使用smtp：100.98.113.250，端口465；**artemis**、LdapSelfPasswd、Gerrit等使用端口25。

> Gerrit Replication无法直接使用100.98.113.250，因为服务所在主机为100.98.113.250后端Real Server。
> 在SLB 4层服务中，阿里云（2016/4/12）不支持添加进后端云服务器池的ECS既作为Real Server，又作为客户端向所在的负载均衡实例发送请求。
