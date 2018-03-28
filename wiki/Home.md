> 欢迎访问DevOpsWiki！请注意，本wiki采用git管理，请勿直接在页面上进行编辑。

> 编辑需访问gitlab获取git仓库，并咨询 [管理员](http://wiki.htrader.cn/Contacts/Contacts)。

## 账号统一管理
LDAP账号统一管理平台目前已集成 [gitlab](http://gitlab.htrader.cn)、[jenkins](http://jenkins.htrader.cn)、[jira](http://jira.htrader.cn)、[openvpn](http://wiki.htrader.cn/openvpn/VPN)、[docker](http://docker.htrader.cn) 平台。

默认LDAP账号为公司邮箱前缀，例如:邮箱为abc@htrader.cn，则对应系统账号为abc，默认密码为 123456。

如果需要修改LDAP账号密码，请点击 [立即修改密码](http://ssp.htrader.cn)，如果忘记LDAP密码，请点击 [找回密码](http://ssp.htrader.cn/?action=sendtoken)。



####注意1
gitlab在RD-office这个wifi的ssid下只有绑定MAC地址的机器才能访问，而Java组的台式机可以直接访问gitlab。

####注意2
如果运维人员，需要对LDAP账号进行编辑的话，可以直接通过[phpldapadmin](http://ldapadmin.htrader.cn/)来处理。


## 信息查询
公司网络设备相关信息：[设备信息列表](http://wiki.htrader.cn/MachineList/EquipmentList)

查看服务器信息：[线下服务器](http://wiki.htrader.cn/MachineList/DevMachineList)、开发测试环境在 [Aliyun服务器](http://wiki.htrader.cn/MachineList/AliyunMachineList)、线上环境在 [Azure服务器](http://wiki.htrader.cn/MachineList/AzureMachineList)。

FTMS项目 底层组件 IP,角色,hosts名 对应关系：[FTMS开发环境](http://wiki.htrader.cn/MachineList/ftms-dev)、[FTMS测试环境](http://wiki.htrader.cn/MachineList/ftms-test)。

##公司监控信息查询
负二楼机房监控：[192.168.30.32](http://192.168.30.32)，用户名admin

财务室监控：[192.168.30.33](http://192.168.30.33)，用户名admin

办公室监控：[192.168.30.34](http://192.168.30.34)，用户名admin

####注意1
建议访问监控需要使用Windows的IE浏览器


## 系统上线准备工作
系统上线准备工作：[准备工作](http://wiki.htrader.cn/MachineList/onlinepro)

## 后端模块负责人

后端组对应模块和运维部相关负责人联系方式
[联系方式](http://wiki.htrader.cn/MachineList/user)

## 发布相关

请务必阅读 [发布申请流程和Git仓库使用规范](http://wiki.htrader.cn/Deploy/DeployRule)。

编写发布文档，请参考 [发布文档示例](http://wiki.htrader.cn/Deploy/Deploy)，并提前将文档发送至ops@htrader.cn。

## Git使用

Git客户端使用请看[Git客户端使用详解](http://wiki.htrader.cn/Git/UseClient/Client)。

## Gitlab使用

Gitlab基本使用请看[Gitlab入门](http://wiki.htrader.cn/Gitlab/migrate)，客户端使用请看[Git客户端使用详解](http://wiki.htrader.cn/Git/UseClient/Client)。

## Jenkins使用

使用 Jenkins ，[jenkisn访问连接](http://jenkins.htrader.cn)，可参考文档[Jenkins平台操作指南](http://wiki.htrader.cn/Jenkins/NewJenkins)。

## OpenVPN使用

在外网，需要连接开发环境服务器，可以使用 [VPN](http://wiki.htrader.cn/openvpn/VPN)。

## Docker私有库

Docker仓库地址，以及提供镜像信息查看的<a href="https://docker.htrader.cn" target="_blank"> web页面</a>，[阅读使用文档](http://wiki.htrader.cn/Docker/harbor)。

## Samba共享使用
在Java组(192.168.1.0/24)网段下访问samba，需要在浏览器中输入samba.htrader.cn中进行访问。而且在该网段下只能下载。

非192.168.1.0/24网段，访问共享地址\\\samba.htrader.cn，使用请看 [共享使用](http://wiki.htrader.cn/Samba/samba)。

## 联系我们

如需联系，请查看[联系方式](http://wiki.htrader.cn/Contacts/Contacts)。
