|名称|位置|内网 IP 地址|公网 IP 地址|正式环境(模块/组件)|配置|备注|磁盘|
|---|---|---|---|---|---|---|---|
|mysqlmaster-adms-210|公司内部|192.168.0.210||adms/mysqlmaster-adms|4c/8G/100G HDD|公司|1|
|mysqlslave-adms-211|公司内部|192.168.0.211||adms/mysqlslave-adms|4c/8G/100G HDD|公司|1|
|azure-btc|东南亚|10.0.0.9|52.187.162.136|btc钱包客户端|2c/8G/30G HDD+1T HDD|端口8332/8333|2|
|azure-eth|东南亚|10.0.0.30|52.163.246.160|eth钱包客户端|2c/8G/30G HDD+1T HDD|端口8545|2|
|azure-online-3rd-10|东南亚|10.0.0.10|-|zookeeper/rabbitmq/mongodb|4c/16G/30G SSD+200G HDD||2|
|azure-online-3rd-11|东南亚|10.0.0.11|-|zookeeper/rabbitmq/mongodb|4c/16G/30G SSD+200G HDD||2|
|azure-online-3rd-12|东南亚|10.0.0.12|-|zookeeper/rabbitmq/mongodb|4c/16G/30G SSD+200G HDD||2|
|azure-online-app-21|东南亚|10.0.0.21|-|trader/woms|2c/8G/30G SSD+500G HDD||2|
|azure-online-app-22|东南亚|10.0.0.22|-|trader/woms|2c/8G/30G SSD+500G HDD||2|
|azure-online-app-23|东南亚|10.0.0.23|-|match/manager/mwms|4c/16G/30G SSD+500G HDD||2|
|azure-online-app-24|东南亚|10.0.0.24|-|match/manager/mwms|4c/16G/30G SSD+500G HDD||2|
|azure-online-app-25|东南亚|10.0.0.25|-|product/market|2c/8G/30G SSD+500G HDD||2|
|azure-online-app-26|东南亚|10.0.0.26|-|product/market|2c/8G/30G SSD+500G HDD||2|
|azure-online-app-27|东南亚|10.0.0.27|-|common/user|2c/8G/30G SSD+200G HDD||2|
|azure-online-app-28|东南亚|10.0.0.28|-|common/user|2c/8G/30G SSD+200G HDD||2|
|azure-online-app-29|东南亚|10.0.0.29|-|pay/interface|2c/8G/30G SSD+200G HDD||2|
|azure-online-app-31|东南亚|10.0.0.31|-|pay/interface|2c/8G/30G SSD+200G HDD||2|
|azure-online-app-32|东南亚|10.0.0.32|-|log/fund|2c/8G/30G SSD+200G HDD||2|
|azure-online-app-33|东南亚|10.0.0.33|-|log/fund|2c/8G/30G SSD+200G HDD||2|
|azure-online-app-34|东南亚|10.0.0.34|-|elastic-job/dubbo-admin|2c/8G/30G SSD+200G HDD||2|
|azure-online-mysqlmaster-user-13|东南亚|10.0.0.13|-|mysqlmaster-(user/woms/mwms)|4c/16G/30G SSD+200G SSD+500G HDD(备份盘)||3|
|azure-online-mysqlslave-user-14|东南亚|10.0.0.14|-|mysqlslave-(user/woms/mwms)|4c/16G/30G SSD+200G SSD+500G HDD(备份盘)||3|
|azure-online-mysqlmaster-trader-15|东南亚|10.0.0.15|-|mysqlmaster-trader|4c/16G/30G SSD+200G SSD+500G HDD(备份盘)||3|
|azure-online-mysqlslave-trader-16|东南亚|10.0.0.16|-|mysqlslave-trader|4c/16G/30G SSD+200G SSD+500G HDD(备份盘)||3|
|azure-online-mysqlmaster-pay-17|东南亚|10.0.0.17|-|mysqlmaster-pay|4c/16G/30G SSD+200G SSD+500G HDD(备份盘)||3|
|azure-online-mysqlslave-pay-18|东南亚|10.0.0.18|-|mysqlslave-pay|4c/16G/30G SSD+200G SSD+500G HDD(备份盘)||3|
|azure-online-redis-06|东南亚|10.0.0.6|-|redis|4c/16G/30G SSD+200G SSD||2|
|azure-online-redis-07|东南亚|10.0.0.7|-|redis|4c/16G/30G SSD+200G SSD||2|
|azure-online-redis-08|东南亚|10.0.0.8|-|redis|4c/16G/30G SSD+200G SSD||2|
|azure-online-web-19|东南亚|10.0.0.19|-|nginx|4c/16G/30G SSD+50G HDD||2|
|azure-online-web-20|东南亚|10.0.0.20|-|nginx|4c/16G/30G SSD+50G HDD||2|
|Japan-online-01|日本西部|10.0.1.4|13.73.232.185|邮箱|2c/8G/30G HDD||1|
|TEST|东南亚|10.0.0.4|52.187.162.50|openvpnclient|1c/3.5G/30G HDD||1|
|zabbixServer|东南亚|10.0.0.5|-|zabbix|2c/8G/64G SSD||1|
