# 新Jenkins平台脚本调用说明文档

> [脚本Git仓库地址](http://gitlab.htrader.cn/#/admin/projects/jenkins)。
> 调用时请加变量`$SHELL/脚本名`，实际是`SHELL`=`sh /home/environment.common/jenkins/shell`。

## 一、maven项目

1、构建前，需获取`autoconfig配置文件`的项目。

**> 从svn仓库获取：get-autoconfig.sh（已废弃）**

功能：获取svn仓库中指定`autoconfig配置文件`到`工程打包目录`下，需传参`autoconfig配置文件svn地址`。

示例: `$SHELL/get-autoconfig.sh  http://xxxxxx/tags/Cupid/autoconfig/dev/sso_antx.properties`

**> 从git仓库获取：get-git-autoconfig.sh**

功能：获取git仓库中指定`autoconfig配置文件`到`工程打包目录`下，需传参`autoconfig配置文件git地址`、`使用的分支或tag名`、`文件相对路径`。

示例: `$SHELL/get-git-autoconfig.sh  ssh://svnuser@gitlab.htrader.cn:22222/Dev/autoconfig  master  test/qa3/cems_antx.properties`

2、部署、运行工程对应服务。

（1）tomcat服务

**deploy-local-tomcat.sh**

功能：部署、运行服务到`tomcat容器`中，需传参`服务目录名`、`War包相对工程目录位置`、`部署到容器中的Webapp名称`、`使用本机Redis的几号database`。

示例：`$SHELL/deploy-local-tomcat.sh  sso_dev3  sso-web/target/sso-web-*.war  ROOT.war  0`

> 脚本执行大致过程：在**构建结束后**，将项目工作目录下产生的`sso-web/target/sso-web-xxx.war`拷贝到名为`sso_dev3`的tomcat容器（从已有的tomcat模板目录拷贝而来，tomcat使用本机Redis 0号database）中部署，并重命名Webapp名称为`ROOT.war`。

**注意：**

*1* tomcat模板目录为`/home/htrader.cn/tomcat-server/DoNotChange/template`，各环境需注意tomcat模板目录下`conf/context.xml`中的`sessionCookiePath`和`RedisSession`的`ip地址`和`端口`。

*2* 名为`sso_dev3`的`tomcat`的监听端口需要**预先**在`/home/htrader.cn/tomcat-server/DoNotChange/ports`文件中配置，内容形如`sso_dev3|8006|8081|9091`;如对应tomcat提供http页面，还需要将对应的端口告知运维人员。

$ cat /home/htrader.cn/tomcat-server/DoNotChange/ports  #如果自行定义了端口信息，则需在nginx上修改对应的upstream

    #APP_NAME|SHUTDOWN|SERVER_PORT|AJP_PORT
    sso_dev3|8006|8081|9091
    cif_dev3|8007|8082|9092
    cif_front_dev3|8008|8083|9093
    clms_dev3|8009|8084|9094
    artemis_dev3|8010|8085|9095

> 查看端口是否被占用，可使用`sudo lsof -i :8081`命令，没有返回则未被占用。若没有`lsof`命令，用`sudo yum install lsof`安装。

（2）java服务：scavenger **（已废弃）**

**deploy-local-scavenger.sh**

功能：部署`scavenger`到指定目录，需传参`服务目录名`、`Zip包相对工程目录位置`。

示例：`$SHELL/deploy-local-scavenger.sh  scavenger_dev3  scavenger.run/target/scavenger.run-0.0.1-SNAPSHOT-jar-with-dependencies.zip`

## 二、自由风格的软件项目

1、nodejs服务

**> 从svn仓库获取：deploy-local-webnode.sh（已废弃）**

功能：部署、运行`web nodejs`服务，需传参`autoconfig配置文件svn地址`。

示例：`$SHELL/deploy-local-webnode.sh  http://xxxxxx/tags/Cupid/autoconfig/dev/node_config.js`

**> 从git仓库获取：deploy-git-local-node.sh（推荐）**

（1）需要先获取配置文件，然后启动的nodejs。

功能：部署、运行`nodejs`服务，传参`autoconfig配置文件git地址`、`使用的分支或tag名`、`文件相对路径`。

部署**nodejs**示例：`$SHELL/deploy-git-local-node.sh  ssh://svnuser@gitlab.htrader.cn:22222/Dev/webnode  master  config_dev`

（2）直接指定环境变量启动的nodejs，如`pm2 start process-pre.json`，其中`pre`为指定的环境变量。

> 注意：启动的nodejs服务请保持和仓库名一致，如仓库名为ams，则启动运行的nodejs名称也是ams。

功能：部署、运行`nodejs`服务，传参`环境变量`。

部署**nodejs**示例：`$SHELL/deploy-git-local-node.sh  pre`

**> 从git仓库获取：deploy-git-local-webnode.sh（暂留，请使用deploy-git-local-node.sh替代）**

**> 从git仓库获取：deploy-git-local-webes6.sh（暂留，请使用deploy-git-local-node.sh替代）**

**> 从git仓库获取：deploy-git-local-zlnode.sh（暂留，请使用deploy-git-local-node.sh替代）**

**> 从git仓库获取：deploy-git-local-zlbossnode.sh（暂留，请使用deploy-git-local-node.sh替代）**

功能：部署、运行`指定nodejs`服务，需传参`autoconfig配置文件git地址`、`使用的分支或tag名`、`文件相对路径`。

部署**webes6 nodejs**示例：`$SHELL/deploy-git-local-webes6.sh  ssh://svnuser@gitlab.htrader.cn:22222/Dev/webes6  master  config_dev`

2、static静态资源

**> 从svn仓库获取：deploy-master-static.sh（已废弃）**

功能：部署`nginx static`静态资源，需传参`资源目录名`，通常是`static1到4`，分别对应Jenkins节点环境`dev1到4`，`staticqa2`对应`qa2环境`，`staticmaster`对应`master环境`。

示例：`$SHELL/deploy-master-static.sh  static3`

**> 从git仓库获取：deploy-git-master-static.sh**

功能：部署`nginx static`静态资源，需传参`资源目录名/规定目录名`。`资源目录名`分别对应Jenkins节点环境，如`static1`对应`dev1环境`，`staticqa2`对应`qa2环境`；`规定目录名`为`CIF_FNT`或`CIF_BOSS`或`CIF_SMOKE`或`CIF_WECHAT`，分别对应前台、后台、微信。

> 注意1：**static静态资源**脚本对应的任务`必须`选择`master节点`。

> 注意2：`资源目录名/规定目录名`如更改，则`必须`修改相应nginx配置。

部署**仟金顶静态资源**示例：`$SHELL/deploy-git-master-static.sh  staticqa3/CIF_FNT`

部署**卓筑网静态资源**示例：`$SHELL/deploy-git-master-static.sh  zzwstaticqa3/CIF_FNT`
