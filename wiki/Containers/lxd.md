## LXD使用

> ubuntu对LXD支持友好，推荐使用Ubuntu 16.04 LTS。

1、获取lxd apt源

    $ add-apt-repository ppa:ubuntu-lxc/lxd-git-master
    $ cat ubuntu-lxc-lxd-git-master-trusty.list
    deb http://ppa.launchpad.net/ubuntu-lxc/lxd-git-master/ubuntu xenial main
    # deb-src http://ppa.launchpad.net/ubuntu-lxc/lxd-git-master/ubuntu xenial main

2、下载lxd相关包

> 如果想让普通用户可直接执行lxc命令，需将用户加入lxd组。

    $ aptitude install lxd lxd-client -y

3、lxd网络配置

早期lxd网络依赖lxc1这个包，lxc1分配一个lxcbr0桥接口。新版本lxd去掉了对lxc1的依赖，分配一个lxdbr0桥接口，并且只在lxd启动时激活，配置文件为`/etc/default/lxd-bridge`。当然，你也可以自定义桥接，并连接一个以太网口。

    $ dpkg-reconfigure -p medium lxd

4、lxd镜像

    $ lxc remote list                                                                  ## 查看镜像源
    +-----------------+------------------------------------------+---------------+--------+--------+
    |      NAME       |                   URL                    |   PROTOCOL    | PUBLIC | STATIC |
    +-----------------+------------------------------------------+---------------+--------+--------+
    | images          | https://images.linuxcontainers.org       | lxd           | YES    | NO     |
    +-----------------+------------------------------------------+---------------+--------+--------+
    | local (default) | unix://                                  | lxd           | NO     | YES    |
    +-----------------+------------------------------------------+---------------+--------+--------+
    | ubuntu          | https://cloud-images.ubuntu.com/releases | simplestreams | YES    | YES    |
    +-----------------+------------------------------------------+---------------+--------+--------+
    | ubuntu-daily    | https://cloud-images.ubuntu.com/daily    | simplestreams | YES    | YES    |
    +-----------------+------------------------------------------+---------------+--------+--------+
    $ lxc image list images:                                                           ## 查看远端镜像源“images”中的镜像
    $ lxc image copy images:debian/jessie/amd64 local: --alias debian [--auto-update]  ## 获取镜像源“images”中“debian/jessie/amd64”，本地命名为debian
    $ lxc image list                                                                   ## 查看镜像源“local”中的镜像
    +--------+--------------+--------+---------------------------------------------+--------+----------+-------------------------------+
    | ALIAS  | FINGERPRINT  | PUBLIC |                 DESCRIPTION                 |  ARCH  |   SIZE   |          UPLOAD DATE          |
    +--------+--------------+--------+---------------------------------------------+--------+----------+-------------------------------+
    | debian | e97312cc09f7 | no     | Debian jessie (amd64) (20160614_22:42)      | x86_64 | 104.05MB | Jun 15, 2016 at 11:10am (UTC) |
    +--------+--------------+--------+---------------------------------------------+--------+----------+-------------------------------+
    |        | c1c8e9dc7ee5 | no     | Centos 6 (amd64) (20160615_02:16)           | x86_64 | 65.73MB  | Jun 16, 2016 at 1:42am (UTC)  |
    +--------+--------------+--------+---------------------------------------------+--------+----------+-------------------------------+
    $ lxc image alias create centos6 c1c8e9dc7ee5                                      ## 对c1c8e9dc7ee5命名（alias）为centos6
    $ lxc image list
    +---------+--------------+--------+---------------------------------------------+--------+----------+-------------------------------+
    |  ALIAS  | FINGERPRINT  | PUBLIC |                 DESCRIPTION                 |  ARCH  |   SIZE   |          UPLOAD DATE          |
    +---------+--------------+--------+---------------------------------------------+--------+----------+-------------------------------+
    | debian  | e97312cc09f7 | no     | Debian jessie (amd64) (20160614_22:42)      | x86_64 | 104.05MB | Jun 15, 2016 at 11:10am (UTC) |
    +---------+--------------+--------+---------------------------------------------+--------+----------+-------------------------------+
    | centos6 | c1c8e9dc7ee5 | no     | Centos 6 (amd64) (20160615_02:16)           | x86_64 | 65.73MB  | Jun 16, 2016 at 1:42am (UTC)  |
    +---------+--------------+--------+---------------------------------------------+--------+----------+-------------------------------+
    $ lxc image export centos6/c1c8e9dc7ee5                                            ## 从镜像导出tar包格式，metadata是较小的那个
    $ lxc image import <metadata tarball> <rootfs tarball> --alias image-alias         ## 从tar包导入镜像，2个tar包，metadata是较小的那个

5、lxd容器

    $ lxc launch images:centos/6/amd64 my-centos6              ## 从远端源“images”启动容器，对应的镜像会在“local”中缓存一份
    $ lxc launch debian my-debian8                             ## 镜像源“local”启动容器，你也可以用lxc init debian my-debian8初始化一个容器但并不启动它
    $ lxc list                                                 ## 查看本地容器
    +------------+---------+---------------------+------+------------+-----------+
    |    NAME    |  STATE  |        IPV4         | IPV6 |    TYPE    | SNAPSHOTS |
    +------------+---------+---------------------+------+------------+-----------+
    | my-debian8 | RUNNING | 10.8.150.46 (eth0)  |      | PERSISTENT | 0         |
    +------------+---------+---------------------+------+------------+-----------+
    | my-cemtos6 | RUNNING | 10.8.150.122 (eth0) |      | PERSISTENT | 0         |
    +------------+---------+---------------------+------+------------+-----------+
    $ lxc info my-centos6                                      ## 查看容器信息
    $ lxc exec my-centos6 -- /bin/bash                         ## 容器执行命令，这里获取了一个bash环境
    $ lxc file pull my-centos6/etc/hosts .                     ## 将容器中/etc/hosts文件获取到本地
    $ lxc file push test my-centos6/tmp/                       ## 将当前test文件上传到容器/tmp/下
    $ lxc file edit my-centos6/tmp/test                        ## 直接编辑容器中/tmp/test文件
    $ lxc exec my-centos6 -- ls /tmp/test
    /tmp/test
    $ lxc start|stop|restart|pause|delete <container>          ## 容器生命周期管理
    $ lxc copy c1 c2                                           ## 复制容器c1，新容器名为c2
    $ lxc move c2 c3                                           ## 重命令c2容器为c3，需stop容器先
    $ lxc publish my-container --alias my-new-image            ## 从容器生成镜像，也可以从容器快照生成镜像

6、lxd快照

    $ lxc snapshot c1 c1-s1                                    ## 对容器c1做快照c1-s1
    $ lxc info c1                                              ## 查看容器资源使用，可查看快照信息
    $ lxc restore c1 c1-s1                                     ## 用快照c1-s1恢复容器c1
    $ lxc move c1/c1-s1 c1/c1-1                                ## 重命名快照
    $ lxc copy c1/c1-1 c3                                      ## 从快照c1/c1-1生成新容器名为c3

7、lxd配置

lxd容器可配置资源、磁盘、开机启动等[设置项](https://github.com/lxc/lxd/blob/master/doc/configuration.md)，除非官方文档明确申明，通常这些配置都可以热更新，不用重启容器。

    $ lxc profile list                                          ## 查看可用的profile配置，profile配置一般设置通用设置项
    default
    docker
    $ lxc profile show default                                  ## 查看“default”配置的设置项内容
    name: default
    config: {}
    description: Default LXD profile
    devices:
      eth0:
        name: eth0
        nictype: bridged
        parent: lxdbr0
        type: nic
    $ lxc profile set <container> <key> <value>                 ## 配置profile设置项
    $ lxc profile edit <profile>                                ## 编辑profile配置
    $ lxc profile apply <container> <profile1>,<profile2>,...   ## 应用profile配置到容器
    $ lxc config set <container> limits.cpu 2                   ## 设置config配置限制容器只可使用2个cpu,config配置一般设置容器特有设置项
    $ lxc config show <container>                               ## 查看容器配置
    name: centos
    profiles:
    - default
    config:
      limits.cpu: "2"
      volatile.base_image: 5214b823f2ef7a11ae34abf9a878f8d3d53f6badc1a4dfe76715baaa67766723
      volatile.eth0.hwaddr: 00:16:3e:9c:48:8c
      volatile.last_state.idmap: '[{"Isuid":true,"Isgid":false,"Hostid":1345184,"Nsid":0,"Maprange":65536},{"Isuid":false,"Isgid":true,"Hostid":1345184,"Nsid":0,"Maprange":65536}]'
    devices:
      root:
        path: /
        type: disk
    ephemeral: false
    $ lxc config edit <container>                               ## 编辑config配置
    $ lxc config device add <container> ...                     ## 增加device，具体语法可查看lxc help config

8、在线迁移

此特性目前为试验特性，可能会无法正常工作。
