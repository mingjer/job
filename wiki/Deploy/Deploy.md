# 发布文档参考示例

* 发布是指发布到线上正式环境。需要开发人员拟好发布文档，提前发送给运维人员进行review确认。

* 当发布文档review定稿后，须在PMS系统相应发布任务中作为附件上传，记录里程碑和版本的备案统计。

* 请务必阅读[发布流程、规法和Git仓库使用规范](http://wiki.htrader.cn/Deploy/DeployRule)。

## 通用模板说明

### 一、变更情况（由开发人员撰写）

> 备注：开发人员需**详细**说明变更内容。如mysql/mongodb等数据库新增/变更库、表、账号等；tomcat/java/nodejs等服务新增/变更/下线情况及部署方式。若没有更变，可不写对应条目。

1、增加

2、更新

3、下线

4、注意事项

### 二、验收情况（由开发人员撰写）

> 备注：开发提供Git仓库、分支、Tag、Sql等，测试人员通过jenkins对“准发布Tag”进行测试验收。

1、Git仓库、分支、Tag、Sql。

2、测试环境验收。

### 三、发布步骤（运维人员撰写）

> 备注：运维人员根据实际发布变更情况和需求，整理发布步骤。

1、发布准备。

2、发布步骤。


## 参考示例

                                Apollo2发布计划

    一、变更情况
    1、新增
    （1）mysql：
           A、新增库clms，表clms_a、clms_b，账号clms/密码单独告知。
           B、新增库ams，表sm_data，账号ams/密码单独告知。
    （2）mongodb：新增库cms，账号cms/密码单独告知。

    2、更新
    （1）mysql：更新表cif_fnt.cif_a。
    （2）tomcat server：更新sso、cif-front服务。
         部署：同线上tomcat，集成redis。
    （3）java server：更新account服务。
         部署：解压account.task-0.0.1-SNAPSHOT-tar-with-dependencies.tar.gz，通过bin目录下脚本start/stop。
    （4）nodejs server：更新web node服务。
         部署：获取资源后，在顶级目录通过pm2启动程序，如pm2 start app.js -i 0 --name Apollo2。
    （5）nginx server：
           A、更新nginx static/CIF_FNT静态资源。
           B、htrader.cn域名:
              （a）添加请求转发规则：
                   .css|.gif|.jpg|.js|.less|.png|.ttf|.woff结尾 ---> static/CIF_FNT;
                   /cif开头 ---> cif-front服务;
              （b）添加头信息：
                   proxy_set_header Q-SCHEME $scheme;
                   proxy_set_header Q-HOST $host;
                   proxy_set_header Q-REQUEST-URI $request_uri;

    3、下线（此条没有变更，可不写）
    无

    4、注意事项
    （1）zookeeper（dubbo）、redis使用原有线上生产环境。
    （2）cif-front服务依赖yunpian短信网关，发信需要。
    （3）nodejs版本使用0.12。

    二、验收情况
    1、发布地址（如果是git仓库，列出git地址，并必须给出**准发布Tag**）
    （1）mysql：
           A、clms库：http://gitlab.htrader.cn/svn/repos/qjdchina/Docs/CLMS/e/sqls/DDL_1.sql
                      http://gitlab.htrader.cn/svn/repos/qjdchina/Docs/CLMS/e/sqls/DDL_2.sql
           B、cif库：http://gitlab.htrader.cn/svn/repos/qjdchina/Docs/CIF_FRONT/p/sqls/DDL_20150929.sql
    （2）tomcat：
           A、Dev/sso
              Tag: d0.0.1-2
           B、Dev/cif-front
              Tag: d0.0.1-1
    （3）java：
           account：http://gitlab.htrader.cn/svn/repos/qjdchina/Apps/tags/Apollo2/account
    （4）nodejs：
           Dev/webnode
           Tag: d0.0.1-1
    （5）nginx static
           Dev/static-front
           Tag: d0.0.2-4
    （6）autoconfig
           autoconfig配置文件在各自项目中，可给出相对路径。

    2、测试环境验收。
     （1）使用环境：Jenkins上qa5环境。
     （2）验收服务：qa5_static、qa5_webnode、qa5_sso、qa5_cif-front、qa5_account。

    三、发布步骤
    1、上线发布准备。
     （1）mongodb数据库变更实施
     （2）mysql数据库变更实施。
     （3）检查确认服务依赖。
     （4）通过jenkins打包。
     （5）分发资源到机器。
     （6）发布策略等其他准备。

    2、上线发布步骤。

    测试通过后，先上线预发布环境。
     （1）确认资源分发情况和发布准备情况，保证数据库变更已实施。
     （2）依次单台更新sso、cif-front、account，无误后更新另一台。
     （3）更新webnode服务，上线nginx规则，并更新static/CIF_FNT资源。
     （4）实施发布操作后，可同测试人员验证。

    在0.5个或1个工作日后，上线生产环境。
     （1）同预发布过程，实施发布步骤。
     （2）发布后验证，保证自启动、进程监控等。
