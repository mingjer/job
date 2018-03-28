# 老 Jenkins 平台操作指南

## 约定

1. 这里的 Jenkins 是指`http://10.1.1.182:8080/jenkins`，部分开发、测试环境的服务构建、部署依赖此 Jenkins 。

2. 总共2套环境（习惯称为`dev[10.1.1.182和10.1.1.62]`、`test[172.16.22.57]`），可供2个项目分别使用；公共组件目前各自使用一套。

3. Master 节点运行在`10.1.1.182`上，构建工作目录`/home/qianjinding/jenkins/jenkins_home/workspace`。Slave 节点运行在`172.16.22.57`上，构建工作目录`/home/qjdadmin/jenkins/jenkins_home/workspace`。

4. Master 节点`tomcat`、`java`服务部署在`10.1.1.62`的`/home/htrader.cn/apps`目录。Slave 节点`tomcat`服务(暂未设置`java`服务)部署在`/home/qjdadmin/qjdchina/apps`目录。

## 架构简介

Jenkins 设置 Master、Slave test-node 2 个节点，分别执行构建任务。其中`dev环境（非test-node）`的`tomcat/java server`部署在`10.1.1.62`上。

    -----------------       Jenkins下发任务       ---------------------------
    \ Jenkins Master \  ----------------------->  \ Jenkins Slave(test-node) \
     -----------------                             ---------------------------
         |                   SSH远程执行           ---------------------
         ----------------------------------------> \ tomcat/java server \
                                                    ---------------------

## 节点（环境）选择

Slave(test-node) 节点只允许运行绑定到这台机器的job。如果一个任务需要在 Slave 节点构建、部署，则需如下设置：

  ![Choice_Slave_Node](OldJenkins/Choice_Slave_Node.jpg)

> 注意，有2个构建节点，因此，不绑定Slave(test-node) 节点的默认跑在 Master 节点。

## 构建扩展

经之前的协商，开发环境 maven 构建时包含测试构建过程（-Dmaven.test.skip=false）。测试环境构建时候关注与 jacoco、sonar的集成，参考如下设置：

  ![Jacoco_And_Sonar](OldJenkins/Jacoco_And_Sonar.jpg)

这里需要根据实际需求选择`Post Steps`的运行条件。

## 项目

**1、maven项目**

目前对应的 maven 项目可大致分为 2 类。

*1-1* 被依赖，构建需要 install 到本地的项目。部分配置示例如下：

  ![Mvn_Need_Install](OldJenkins/Mvn_Need_Install.jpg)

*1-2* 构建前后有`Pre Steps`和`Post Steps`的项目。此类项目通过调用脚本（不是使用部署插件），自动部署项目到了 tomcat 容器。

  ![Mvn_Use_Shell](OldJenkins/Mvn_Use_Shell.jpg)

脚本内容可在 Master 或 Slave test-node 节点对应路径下查看。这里说明下示例（运行在Slave test-node 节点，即`172.16.22.57`）中的`prebuild.sh`和`deploy-local.sh`，脚本所在路径为`/home/qjdadmin/jenkins/shells`（Master节点脚本在`/home/qianjinding/jenkins/shells`）。

*1-2-1*

  ![Prebuild](OldJenkins/Prebuild.jpg)

指在**构建前**，从 svn 仓库中导出 cif_front_antx.properties 配置文件到项目的工作目录中，并重命名为 antx.properties 。

*1-2-2*

  ![DeployLocal](OldJenkins/DeployLocal.jpg)

指在**构建后**，将项目工作录下产生的 cif.fnt.web/target/cif.fnt.web-0.0.1-SNAPSHOT.war 拷贝到名为 cif_front_test 的 tomcat 容器中部署，并重命名为 cif.war。需要注意的是，名为 cif_front_test 的 tomcat 的监听端口需要预先在 apps/ports 文件中定义。当前，测试环境 ports 文件内容如下：

$ cat /home/qjdadmin/qjdchina/apps/ports

    #APP_NAME|SHUTDOWN|SERVER_PORT|AJP_PORT
    sso_test|8006|8081|9091
    cif_test|8007|8082|9092
    cif_front_test|8008|8083|9093

> deploy-local.sh 是在构建节点主机上本地部署。dev环境（Master节点）中使用了 deploy-remote.sh，不是在构建节点本地部署，而是部署在了远端另一台开发机器上 10.1.1.62。

**2、自由风格的软件项目**

主要用于静态资源的更新和部署nodejs。

*2-1* DeployStatic

  ![DeployStatic](OldJenkins/DeployStatic.jpg)

静态资源可根据实际需求设置构建触发，这里设置了每小时自动构建一次。依赖脚本 deployStatic-local.sh，功能就是自动 svn update 更新代码。

*2-2* Node

  ![Node](OldJenkins/Node.jpg)

依赖脚本 node-local.sh 中的定义，功能是 svn update 更新代码，并拉取特定位置的配置文件，然后 reload 服务。

## 其他

1、jenkins启动加载环境变量

    $ grep JENKINS_HOME catalina.sh
    export JENKINS_HOME=/srv/qjd/midleware/jenkins_home

2、ProcessTree参数，防止jenkins启动tomcat服务失败

Master节点：

    $ grep ProcessTree catalina.sh
    JAVA_OPTS="-Dhudson.util.ProcessTree.disable=true"

Slave节点：

    $ cat slave.sh    ## 启动脚本，加了 -Dhudson.util.ProcessTree.disable=true 参数
    java -Dhudson.util.ProcessTree.disable=true -jar slave.jar -jnlpUrl http://IP:PORT/jenkins/computer/test-node/slave-agent.jnlp -secret XXXXXX  &

3、DNSMultiCast参数，禁止DNS多播特性，防止错误信息撑满log文件

    $ grep DNSMultiCast catalina.sh
    JAVA_OPTS="-Dhudson.DNSMultiCast.disabled=true"

> [Jenkins Features Controlled with System Properties](https://wiki.jenkins-ci.org/display/JENKINS/Features+controlled+by+system+properties)
