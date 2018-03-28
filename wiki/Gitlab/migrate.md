gitlab登陆地址：[gitlab.htrader.cn](http://gitlab.htrader.cn/users/sign_in)，用户名和密码是和ldap同步的。
### 1.添加ssh公钥
登陆到gitlab，使用自己的ldap用户名和密码（邮箱前缀和邮箱密码），在此以gitlab这个用户为例，

### 2.创建gitlab项目
创建gitlab仓库，在此我们以创建ftms仓库为例，如下：
在此，我们让ftms仓库是私有仓库，也就是说目前该仓库只有gitlab这个用户具有所有权，其他用户不具有访问权限。
 
通过视图我们可以看到，ftms在gitlab中的仓库地址是：

ssh形式：git@gitlab.htrader.cn:gitlab/ftms.git

http形式：http://gitlab@gitlab.htrader.cn/gitlab/ftms.git

### 3.配置gitlab仓库访问权限
在gitlab上，切换到项目仓库管理页面，在此我们以把项目仓库让wangxy这个用户具有管理员权限为例，如下：
 
以上是对用户权限的配置，除此之外还需要开启另外一个配置：
 
### 4.配置gitlab发送邮件通知
gitlab默认已经配置了对push tag发送邮件的配置，并且对邮件通知的用户也进行了相关的配置。如果要修改邮件通知的用户，以及想对push也发送邮件的话，可以查看：
 
图中的trigger是配置相关的触发器，Recipients是配置要通知的人的邮箱地址
Send from committer选项一定不要启用，否则无法发送邮件

### 5.修改jenkins相关配置
登陆到jenkins，找到相关job，点击配置，修改git仓库地址：
注意选择正确的认证，和填写正确的gitlab仓库地址，然后点击保存即可

### 6.删除gitlab仓库
在gitlab上，切换到ftms仓库管理页面：

注意：非gitlab管理员用户，只能删除自己创建的gitlab仓库
