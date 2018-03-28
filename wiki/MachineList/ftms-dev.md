|###阿里云【开发】环境(cluster)||||
|---|---|---|---|
|Mysql（3306）||||
|---|主|172.16.229.252|mysqlmaster.rd|
|---|从|172.16.229.253|mysqlslave.rd|
|---||||
|---|主|172.16.229.252|mysqlmaster-woms.rd|
|---|从|172.16.229.253|mysqlslave-woms.rd|
|---||||
|---|主|172.16.229.252|mysqlmaster-adms.rd|
|---|从|172.16.229.253|mysqlslave-adms.rd|
|---||||
|---|主|172.16.229.252|mysqlmaster-ftmsuser.rd|
|---|从|172.16.229.253|mysqlslave-ftmsuser.rd|
|---||||
|---|主|172.16.229.252|mysqlmaster-ftmspay.rd|
|---|从|172.16.229.253|mysqlslave-ftmspay.rd|
|---||||
|---|主|172.16.229.252|mysqlmaster-ftmstrader.rd|
|---|从|172.16.229.253|mysqlslave-ftmstrader.rd|
|Zookeeper(2181)||||
|---|leader|172.16.229.230|zookeeper-2.rd|
|---|follower|172.16.229.228|zookeeper-1.rd|
|---|follower|172.16.229.233|zookeeper-3.rd|
|Mongodb(27017)||||
|---|primary|172.16.229.228|mongodb-1.rd|
|---|secondary|172.16.229.230|mongodb-2.rd|
|---|secondary|172.16.229.233|mongodb-3.rd|
|rabbitmq(5672)||||
|---|磁盘模式|172.16.229.228|rabbitmq-1.rd|
|---|内存模式|172.16.229.230|rabbitmq-2.rd|
|---|内存模式|172.16.229.233|rabbitmq-3.rd|
|redis(6379)||||
|---|主，哨兵|172.16.229.228|redis-1.rd|
|---|从，哨兵|172.16.229.230|redis-2.rd|
|---|从，哨兵|172.16.229.233|redis-3.rd|
|---||||