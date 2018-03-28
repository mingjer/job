# Nodejs

## 版本

生产环境推荐使用[LTS版本](https://github.com/nodejs/LTS)。我们目前使用了v5.x版本。

## 安装

推荐使用包管理器[安装](https://github.com/nodesource/distributions#rpminstall)，这里以v5.x版本为例。

1.获取yum源：

> 我们的环境已经用puppet预设置nodejs源，可直接从第2步开始。

    $ sudo curl --silent --location https://rpm.nodesource.com/setup_5.x | sudo bash -

2.安装Nodejs：

    $ sudo yum install nodejs

3.版本信息（2016/4/5）

    $ node -v
    v5.10.0
    $ npm -v
    3.8.3

## 扩展安装pm2

#### 如只是某个账号（例如A账号）需使用pm2，可用npm安装。

1.这里安装到/home/environment.common/nodejs目录下：

    [A@~]$ cd /home/environment.common/nodejs
    [A@ ]$ npm install pm2
    [A@ ]$ ls
    node_modules

2.配置环境变量PATH：

    [A@ ]$ cd
    [A@~]$ vi .bashrc  ## 增加如下设置
    PM2_HOME=/home/environment.common/nodejs/node_modules/pm2
    export PATH=$PATH:$PM2_HOME/bin
    [A@~]$ source .bashrc  ## 或重新登录

3.检验pm2命令是否已经加入PATH，并生效:

    [A@ ~]$ which  pm2
    /home/environment.common/nodejs/node_modules/pm2/bin/pm2

#### 如需全局（所有用户）需使用pm2，使用root权限npm加-g参数安装。

1.root权限安装pm2：

    [root@ ]$ npm install pm2 -g

2.检验pm2命令：

    [root@ ]$ which  pm2
    /bin/pm2

## npm配置文件设置npm源，如为内网，也可在这里设置代理

    $ cat ~/.npmrc
    registry=https://registry.npm.taobao.org/  ## npm使用taobao源
    proxy=http://Ip:Port                       ## http代理，例如100.98.113.250:3128
    https-proxy=http://Ip:Port                 ## https代理

## 使用cnpm

    $ npm install -g cnpm --registry=https://registry.npm.taobao.org

## 升级

1、升级nodejs和npm版本，直接覆盖安装即可

    $ sudo yum install nodejs

2、升级全局pm2程序版本

    $ sudo npm install pm2 -g

3、注意，如果A账号下有已运行的pm2 app，需要**切换到A账号**，并使用`pm2 update`命令将其升级

    [A@ ]$ pm2 update

## 异常

1、pm2 启动出现error，但是用node启动验证无报错，日志没有发现异常情况，其它nodejs项目构建也是如此，解决方法

    $ sudo pm2 updatePM2

2、如果上面的方法不行可尝试下面的方法

    $ ps aux| grep PM2| awk '{print $2}'| xargs sudo kill -9

杀掉进程后重启nodejs的项目

## es6 gulp编译

1、安装软件包

    $ sudo npm install webpack babel babel-core gulp babel-loader gulp-ruby-sass jsx-loader webpack-dev-server gem -g

2、进入到nodejs目录下进行编译

    $ gulp build-dev

## npm 私有库使用

1、更改npm源，更改配置后下载npm包默认先从私有库去下载，如果私有库中没有则去淘宝的npm仓库中去下载

    $ vim ~/.npmrc
    registry = http://10.1.1.184/nexus/content/groups/npm-all/
    init.author.name=deployment
    email=svnuser@htrader.cn
    always-auth=true
    _auth=ZGVwbG95bWVudDpEZXBsb3kxMjM=

2、发布npm包到私有库

    $ vim package.json    #加上下面这三行
    "publishConfig" : {
        "registry" : "registry = http://10.1.1.184/nexus/content/repositories/npm-internal/"
    }
    $ npm publish
