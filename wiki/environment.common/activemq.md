# activemq

## 版本

apache-activemq-5.12.0-bin.tar.gz

## 安装部署方法

（1）解压缩

tar zxf apache-activemq-5.12.0-bin.tar.gz

（2）根据实际情况，修改配置文件`apache-activemq-5.12.0/conf/jetty.xml`中jetty监听ip和端口。

示例：

    $ grep -A 4 'id="jettyPort"' jetty.xml
    <bean id="jettyPort" class="org.apache.activemq.web.WebConsolePort" init-method="start">
             <!-- the default port number for the web console -->
        <property name="host" value="0.0.0.0"/>
        <property name="port" value="8161"/>
    </bean>


（3）根据实际情况，修改配置文件`apache-activemq-5.12.0/conf/jetty-realm.properties`中web user账号、密码信息。

示例：

    # Defines users that can access the web (console, demo, etc.)
    # username: password [,rolename ...]
    admin: adminpassword, admin
    user: userpassword, user

（4）修改配置文件`apache-activemq-5.12.0/conf/activemq.xml`，构建3节点集群。

示例：

    $ diff -u activemq.xml.origin activemq.xml
    --- activemq.xml.origin    2015-10-10 09:53:02.370336658 +0800
    +++ activemq.xml           2015-10-10 09:58:56.954762416 +0800
    @@ -37,7 +37,7 @@
         <!--
             The <broker> element is used to configure the ActiveMQ broker.
         -->
    -    <broker xmlns="http://activemq.apache.org/schema/core" brokerName="localhost" dataDirectory="${activemq.data}">
    +    <broker xmlns="http://activemq.apache.org/schema/core" brokerName="dev" dataDirectory="${activemq.data}">  ## 注意brokerName

             <destinationPolicy>
                 <policyMap>
    @@ -78,10 +78,22 @@

                 http://activemq.apache.org/persistence.html
             -->
    -        <persistenceAdapter>
    +<!--        <persistenceAdapter>
                 <kahaDB directory="${activemq.data}/kahadb"/>
             </persistenceAdapter>
    +-->

    +       <persistenceAdapter>
    +               <replicatedLevelDB
    +                       directory="${activemq.data}/leveldb"
    +                       replicas="3"  ## 3节点
    +                       bind="tcp://0.0.0.0:0"  ## 绑定为tcp://0.0.0.0:0
    +                       zkAddress="10.1.1.182:2181,10.1.1.185:2181,10.1.1.186:2181"  ## zk集群地址
    +                       zkSessionTimeout="4s"  ## 超时时间
    +                       hostname="10.1.1.186"  ## 各节点为本机地址
    +                       sync="local_disk"
    +                       zkPath="/activemq/leveldb-stores"
    +               />
    +       </persistenceAdapter>

               <!--
                 The systemUsage controls the maximum amount of space the broker will
    @@ -111,10 +123,11 @@
             <transportConnectors>
                 <!-- DOS protection, limit concurrent connections to 1000 and frame size to 100MB -->
                 <transportConnector name="openwire" uri="tcp://0.0.0.0:61616?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>  ## tcp
    -            <transportConnector name="amqp" uri="amqp://0.0.0.0:5672?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
    +<!--            <transportConnector name="amqp" uri="amqp://0.0.0.0:5672?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
                 <transportConnector name="stomp" uri="stomp://0.0.0.0:61613?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
                 <transportConnector name="mqtt" uri="mqtt://0.0.0.0:1883?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
                 <transportConnector name="ws" uri="ws://0.0.0.0:61614?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
    +-->
             </transportConnectors>

             <!-- destroy the spring context on shutdown to stop jetty -->
    @@ -133,4 +146,4 @@
         <import resource="jetty.xml"/>

     </beans>
    -<!-- END SNIPPET: example -->
    \ 文件尾没有 newline 字符
    +<!-- END SNIPPET: example -->

（5）服务启停

`apache-activemq-5.12.0/bin/linux-x86-64/activemq`加参数，如start、stop。
