# Mysql Server

## 版本

5.6.x

## 安装部署

1.安装：

    $ yum install mysql-community-server

2.修改配置文件

    $ vi /etc/my.cnf                            ## 根据需求修改
    [mysql]
    default-character-set=utf8
    [mysqld]
    character_set_server=utf8
    collation-server=utf8_general_ci
    lower_case_table_names=1
    enforce_gtid_consistency = on               ## 此行以上为必须保证的条目

    datadir=/home/environment.common/mysqldb    ## 根据实际情况调整
    socket=/var/lib/mysql/mysql.sock

3.重启Mysql，配置生效

    $ sudo mkdir /home/environment.common/mysqldb
    $ sudo chown mysql.mysql /home/environment.common/mysqldb -R
    $ sudo systemctl restart mysqld.service

4.设置admin账号

    $ mysql -u root
    mysql> show grants for root@localhost;  ## 查看、参考root权限
    +---------------------------------------------------------------------+
    | Grants for root@localhost                                           |
    +---------------------------------------------------------------------+
    | GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION |
    | GRANT PROXY ON ''@'' TO 'root'@'localhost' WITH GRANT OPTION        |
    +---------------------------------------------------------------------+
    2 rows in set (0.00 sec)
    mysql> GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'admin的密码' WITH GRANT OPTION;
    mysql> GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' IDENTIFIED BY 'admin的密码' WITH GRANT OPTION;
    mysql> FLUSH PRIVILEGES;
    mysql> quit
    Bye

5.Mysql安全加固

用admin账号登录验证成功后，使用mysql_secure_installation进行Mysql安全加固。

    $ sudo mysql_secure_installation  ## 根据提示进行输入

6.Mysql自动备份

先切换到qianjinding用户

	$mkdir ~/mysql-back
	$vim ~/mysql-back/mysqldump.sh  ## 根据当前环境和需求修改脚本
		#!/bin/sh

		DATE=$(date +%Y%m%d)
		BDATE=$(date -d "7 days ago" +%Y%m%d)
		DUMP_DIR=/home/qianjinding/mysql-back/dump-$DATE
		BDUMP_DIR=/home/qianjinding/mysql-back/dump-$BDATE
		TIME=$(date +%Y%m%d-%H-%M-%S)
		DATABASE=$(mysql -uadmin -pwestos -e "show databases"|egrep -v "Database|mysql|performance_schema|information_schema"|xargs)

		[ -d $BDUMP_DIR ] && rm -rf $BDUMP_DIR
		[ -d $DUMP_DIR ] || mkdir $DUMP_DIR
		for i in $DATABASE
		do
		        mysqldump -uadmin -pwestos --opt --default-character-set=utf8 --hex-blob $i --skip-triggers > $DUMP_DIR/$i-$TIME.sql
		done
	$crontab -e  ## 通过计划任务自动备份
		30 0 * * * /bin/sh /home/qianjinding/mysql-back/mysqldump.sh > /dev/null 2>&1

7.Mysql开启二进制日志

	$sudo vim /etc/my.cnf ## 在[mysqld]的下面添加以下几行
		log-bin=/srv/logs/mysql-binlog/mysql-binlog
		binlog_forma=ROW
		binlog_row_image=full
		log_bin_trust_function_creators=1
		expire_logs_days=7
		max_binlog_size=300M
	$sudo mkdir /srv/logs/mysql-binlog
	$sudo chown mysql.mysql /srv/logs/mysql-binlog
	$sudo systemctl restart mysqld.service

8.MySQL数据导入导出

数据导出(单个库)

        $mysqldump -uusername -ppassword --opt --default-character-set=utf8 --hex-blob dbname --skip-triggers > dbname-$(date +%Y%m%d-%H_%M).sql
        例如: mysqldump -uadmin -pwestos --opt --default-character-set=utf8 --hex-blob ams --skip-triggers > ams-$(date +%Y%m%d-%H_%M).sql

注意: 其中username、password和dbname记得改成具体的用户名、密码和数据库名,下同

数据导入

        mysql -uusername -ppassword dbname <dbname-xxx.sql
        例如: mysql -uadmin -pwestos ams <ams-20160706-11_22.sql 

注意: 数据导入会将原来的数据覆盖，如果数据比较重要可以用上面mysqldump的命令将原来的数据先备份，mysqldump命令的使用也可以参考 https://help.aliyun.com/document\_detail/26133.html?spm=5176.product8314883\_26090.6.131.gSJmGU （里面第一步可以忽略，千万不要关闭数据库）
 
如果是整个实例的数据库都要导出,可以参考6里面的备份脚本,修改DUMP_DIR和BDUMP_DIR的路径后运行脚本即可


## 版本控制

数据库表结构和基础数据使用 git + flyway 进行版本控制，执行需传入环境参数env（如pre、online等）。

1.对未使用flyway管理的数据库初始化。

（1）若数据库为空（没有任何表和数据），初始化命令如下：

    mvn clean install
    mvn flyway:clean -P env

（2）若数据库已存在表结构/基础数据，需以当前数据为基线初始化:

    mvn clean install
    mvn flyway:baseline -P env

2.初始化flyway后，每次执行和升级版本使用如下命令即可：

    mvn clean install
    mvn flyway:migrate -P env
