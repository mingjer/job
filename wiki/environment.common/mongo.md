## mongodb

## 常用操作

1、远程连接interface库：mongo 10.1.1.184:27017/interface -u user -p password

> 集群的话，请链接master节点。

2、查看库、集合信息：show dbs;show collections;

3、用户认证：use interface;db.auth("user", "password")

4、interface.serviceTest数据导出：mongodump -d interface -c serviceTest；accountdb库导出：mongodump -h 10.1.1.184:27017 -u accountdb  -d accountdb

5、导入数据到irfdb.serviceTest：mongorestore --db irfdb --collection serviceTest dump/interface/serviceTest.bson --host qianjinding-dev4 --port 27017 --username user --password password

6、创建用户：db.createUser({"user":"accountdb-pre","pwd":"accountdb-pre","roles":[{role:"readWrite",db:"accountdb-pre"}]}) 

7、删除库：use interface;db.dropDatabase()；删除collection：db.COLLECTION_NAME.drop()

8、导出tender-pre库tenderInfo集合中type字段到outfile，不加--csv则为json格式：mongoexport -h 10.171.250.51:27017 -u tender -p -d tender-pre -c tenderInfo -f type --csv -o outfile

9、集合中的数据增删改查:

　　增： db.collections.insert({})  
　　删： db.collections.remove({})  
　　改： db.collections.update({})  
　　查： db.collections.find({})
