|环境|模块/组件|内网IP地址|公网IP地址|备注|配置|服务器名称|账号|位置|
|---|:----:|---|---|---|---|---|---|---|
|ftms.test|(manager; match; woms; adms; mwms)|172.16.229.235|118.31.72.91||8c/16G/200G/5M|aliyun-test-app-235|andy123lida|华东|
|ftms.test|(elastic-job; dubbo-admin; manager; match; woms; adms; mwms)|172.16.229.221|120.27.216.99|elastic-job(8899),dubbo-admin(8989)|8c/16G/200G/10M|aliyun-test-app-221|andy123lida|华东|
|ftms.test|mysqlslave-pay|172.16.229.251|47.98.44.155||4c/8G/100G/10M|aliyun-test-mysql-pay-slave-251|andy123lida|华东|
|ftms.test|mysqlmaster-pay|172.16.229.250|47.98.43.124||4c/8G/100G/10M|aliyun-test-mysql-pay-250|andy123lida|华东|
|ftms.test|mysqlslave-trader|172.16.229.249|47.98.37.20||4c/8G/100G/10M|aliyun-test-mysql-trader-slave-249|andy123lida|华东|
|ftms.test|mysqlmaster-trader|172.16.229.239|47.98.38.85||4c/8G/100G/10M|aliyun-test-mysql-trader-239|andy123lida|华东|
|ftms.test|(trader; pay)|172.16.229.241|47.98.41.217||2c/4G/100G/15M|aliyun-test-app-241|andy123lida|华东|
|ftms.test|(interface; product)|172.16.229.246|47.98.44.55||2c/4G/100G/15M|aliyun-test-app-246|andy123lida|华东|
|ftms.test|(trader; product)|172.16.229.240|47.98.47.43||2c/4G/100G/15M|aliyun-test-app-240|andy123lida|华东|
|ftms.test|(interface; market)|172.16.229.247|47.98.47.0||2c/4G/100G/15M|aliyun-test-app-247|andy123lida|华东|
|ftms.test|(user; pay)|172.16.229.242|47.98.47.166||2c/4G/100G/15M|aliyun-test-app-242|andy123lida|华东|
|ftms.test|(user; log)|172.16.229.243|47.98.45.182||2c/4G/100G/15M|aliyun-test-app-243|andy123lida|华东|
|ftms.test|(fund; common)|172.16.229.244|47.98.47.59||2c/4G/100G/15M|aliyun-test-app-244|andy123lida|华东|
|ftms.test|(common; log)|172.16.229.248|47.98.35.162||2c/4G/100G/15M|aliyun-test-app-248|andy123lida|华东|
|ftms.test|(fund; market)|172.16.229.245|47.98.42.41||2c/4G/100G/15M|aliyun-test-app-245|andy123lida|华东|
|ftms.test|3rd(zookeeper/redis/mongodb/rabbitmq)|172.16.229.231|116.62.128.214||4c/8G/40G/5M|aliyun-test-3rd-231|andy123lida|华东|
|ftms.test|3rd(zookeeper/redis/mongodb/rabbitmq)|172.16.229.232|47.96.154.84||4c/8G/40G/5M|aliyun-test-3rd-232|andy123lida|华东|
|ftms.test|3rd(zookeeper/redis/mongodb/rabbitmq)|172.16.229.229|121.43.160.233||4c/8G/40G/5M|aliyun-test-3rd-229|andy123lida|华东|
|ftms.test|mysqlmaster-(user; woms; adms; mwms)|172.16.114.39|116.62.189.166||4c/8G/40G/5M|aliyun-test-mysql-39|andy123lida|华东|
|ftms.test|mysqlslave-(user; woms; adms; mwms)|172.16.114.40|47.96.189.212|测试从库1|4c/8G/40G/5M|aliyun-test-mysql-40|andy123lida|华东|
|ftms.dev|app|172.16.229.234|47.96.155.161||2c/8G/200G/5M|aliyun-dev-app-234|andy123lida|华东|
|ftms.dev|app,elastic-job,dubbo-admin|172.16.114.38|116.62.114.95|elastic-job(8899),dubbo-admin(8989)|4c/16G/200G/5M|aliyun-dev-app-38|andy123lida|华东|
|ftms.dev|3rd(zookeeper/redis/mongodb/rabbitmq)|172.16.229.228|47.96.132.245||2c/4G/40G/5M|aliyun-dev-3rd-228|andy123lida|华东|
|ftms.dev|3rd(zookeeper/redis/mongodb/rabbitmq)|172.16.229.233|120.55.40.35||2c/4G/40G/5M|aliyun-dev-3rd-233|andy123lida|华东|
|ftms.dev|3rd(zookeeper/redis/mongodb/rabbitmq)|172.16.229.230|47.96.30.131||2c/4G/40G/5M|aliyun-dev-3rd-230|andy123lida|华东|
|ftms.dev|mysql.slave-2|172.16.229.224|116.62.133.165|~~弃用~~|4c/8G/40G/5M|aliyun-dev-mysql-224|andy123lida|华东|
|ftms.dev|mysql.master|172.16.229.222|116.62.17.224|~~弃用~~|4c/8G/40G/5M|aliyun-dev-mysql-222|andy123lida|华东|
|ftms.dev|mysql.slave|172.16.229.237|116.62.124.166|~~弃用~~|2c/4G/40G/5M|aliyun-dev-mysql-237|andy123lida|华东|
|ftms-dev|mysql.slave|172.16.229.253|47.97.211.229|在用|4c/8G/100G/10M|aliyun-test-mysql-slave-253|andy123lida|华东|
|ftms-dev|mysql.master|172.16.229.252|47.96.158.175|在用|4c/8G/100G/10M|aliyun-test-mysql-master-252|andy123lida|华东|
|ftms.front|开发和测试环境的nginx|172.16.229.227|47.96.181.202||2c/4G/40G/5M|aliyun-test-web-227|andy123lida|华东|
|ftms.front|开发和测试环境的nginx|172.16.229.226|47.96.176.187||2c/4G/40G/5M|aliyun-test-web-226|andy123lida|华东|
|ftms-yali|压力测试机器|172.16.229.238|47.97.202.125|administrator/ht@123456|4c/8G/80G/1M|aliyun-test|andy123lida|华东|
|backupserver|备份服务器|172.31.65.238|47.75.66.73|root|2c/4G/1000G/1M||andy123lida|香港|
|spr.test|openvpnclient|172.16.229.225|120.27.226.104||2c/16G/200G/17M|testserver_spr|andy123lida|华东|
|spr.dev|-|172.16.229.223|121.196.192.185||2c/16G/200G/10M|devserver_spr|andy123lida|华东|
