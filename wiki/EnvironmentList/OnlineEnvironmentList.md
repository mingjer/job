# OnlineEnvironment List

## 示例

    主机名				ip				系统版本
        |
        \ 服务版本			监听				自启动

## 线上

    zk1(myid 1)			10.171.240.41			CentOS7
      |
      \ zookeeper-3.4.6(tar)	0.0.0.0:2181(2888:3888)		y
      \ activemq-5.12.0(tar)	0.0.0.0:8161(tcp61616)		y

    zk2(myid 2)			10.252.143.141			CentOS7
      |
      \ zookeeper-3.4.6(tar)	0.0.0.0:2181(2888:3888)		y
      \ activemq-5.12.0(tar)	0.0.0.0:8161(tcp61616)		y

    zk3(myid 3)			10.171.243.19			CentOS7
      |
      \ zookeeper-3.4.6(tar)	0.0.0.0:2181(2888:3888)		y
      \ activemq-5.12.0(tar)	0.0.0.0:8161(tcp61616)		y

    dubbo-monitor			10.165.99.1			CentOS7
      |
      \ dubbo-monitor-simple-2.5.4-SNAPSHOT-assembl(tar)	0.0.0.0:18080/10.165.99.1:17070		y

    redis1				10.251.252.11			CentOS7
      |
      \ redis-2.8.19(yum)		0.0.0.0:6379			y

    redis2				10.171.216.132			CentOS7
      |
      \ redis-2.8.19(yum)		0.0.0.0:6379			y

    nginx1				10.252.129.50			CentOS6
      |
      \ nginx-1.6.3(yum)		0.0.0.0:80,433			y

    nodejs1				10.252.136.146			CentOS6
      |
      \ nodejs-0.12.2(tar)		0.0.0.0:3000/3001		y

    nodejs3				10.252.136.146			CentOS7
      |
      \ nodejs-0.12.2(tar)		0.0.0.0:3001			y

    nginx3				10.251.254.159			CentOS6
      |
      \ nginx-1.6.3(yum)		0.0.0.0:80			y

    sso1				10.175.199.142			CentOS7
      |
      \ ROOT.war/tomcat7		0.0.0.0:20880/8005,8080,8009	y

    sso2				10.252.144.180			CentOS7
      |
      \ ROOT.war/tomcat7		0.0.0.0:20880/8005,8080,8009	y

    rds
      |
      \ MySQL5.6			rdsremvbzuyvvia.mysql.rds.aliyuncs.com:3306

    cif1				10.171.233.135			CentOS7
      |
      \ ROOT.war/tomcat7		0.0.0.0:20881/8005,8080,8009	y

    cif2				10.171.234.189			CentOS7
      |
      \ ROOT.war/tomcat7		0.0.0.0:20881/8005,8080,8009    y

    cif-front1			10.171.233.135			CentOS7
      |
      \ cif.war/tomcat7		8005,8080,8009			y

    cif-front2			10.252.147.245			CentOS7
      |
      \ cif.war/tomcat7		8005,8080,8009			y

    clms1				10.171.247.149			CentOS7
      |
      \ clms.war/tomcat7		8005,8080,8009			y

    clms2				10.175.199.188			CentOS7
      |
      \ clms.war/tomcat7		8005,8080,8009			y

    artemis1			10.117.4.84			CentOS7
      |
      \ ROOT.war/tomcat7		8005,8080,8009			y

    artemis2			10.51.16.52			CentOS7
      |
      \ ROOT.war/tomcat7		8005,8080,8009			y

    account1			10.165.96.65			CentOS7
      |
      \ account.war/tomcat7		8080				y

    account2			10.51.19.3			CentOS7
      |
      \ account.war/tomcat7		8080				y

    ams1				10.51.3.178			CentOS7
      |
      \ ams.war/tomcat7		8005,8080,8009			y

    ams2				10.117.6.247			CentOS7
      |
      \ ams.war/tomcat7		8005,8080,8009			y

    cems1				10.171.238.100			CentOS7
      |
      \ cems.war/tomcat7		8005,8080,8009			y

    cems2				10.117.12.155			CentOS7
      |
      \ cems.war/tomcat7		8005,8080,8009			y

## 数据库查询

1、登录跳板机

2、登录/查询数据库

    预发环境：直接执行 presqlquery
