## gfs

* glusterfs(以下简称gfs)[官方文档](http://gluster.readthedocs.org/en/latest/)。
* 目前，brick有cif_fnt、clms、cems。

## 客户端(Native Client)挂载使用gfs

> 这里假设gfs server为gfs1、gfs2，brick为cif\_fnt，客户端挂载点为/srv/upload/cif\_fnt。注意，以下操作在client上。

1、下载依赖包

    $ yum install glusterfs glusterfs-fuse -y

2、mount设置

    $ grep -B 1 gfs /etc/fstab  ## 查看/etc/fstab中有关gfs内容
    ## Remember put it in /etc/rc.d/rc.local
    gfs1:/cif_fnt /srv/upload/cif_fnt glusterfs defaults,_netdev 0 0

3、挂载gfs

    $ mkdir /srv/upload/cif_fnt      ## 新加挂载点目录，如已存在请注意是否已有数据
    $ mount -a                       ## 挂载fstab中的内容
    $ df -h
    gfs1:/cif_fnt    50G  6.9G   40G  15% /srv/upload/cif_fnt

4、设置开启自动挂载

> 实测fstab开机挂载gfs失效，故使用rc.local

    $ grep gfs /etc/rc.d/rc.local
    mount -t glusterfs -o backupvolfile-server=gfs2 gfs1:/cif_fnt /srv/upload/cif_fnt
    $ chmod +x /etc/rc.d/rc.local

5、权限问题

通常来讲，客户端挂载gfs brick后即可用，但往往多台主机会挂载同一个brick使用。当同一个用户在不同主机拥有不同的uid，或不同主机不同的用户拥有同样的uid，则挂载后权限将混乱。

官方文档关于权限方面有[ACLs控制的方法](http://gluster.readthedocs.org/en/latest/Administrator%20Guide/Access%20Control%20Lists/)，但实际测试中发现ACLs具有局限性。因此，解决办法只有保持同使用一个brick的用户uid一致，或考虑使用NFS挂载的方式。

## 添加新的brick

> 这里假设新的brick为upload。注意，以下操作在server上。

1、在2台server上新建目录。

    $ mkdir /srv/brick/upload

2、在其中一台server上设置replica volume。

    $ sudo gluster volume create upload replica 2 gfs1:/srv/brick/upload gfs2:/srv/brick/upload
    volume create: upload: success: please start the volume to access data

3、启动volume。

    $ sudo gluster volume start upload
    volume start: upload: success

4、设置volume参数。

    $ sudo gluster volume set upload nfs.disable true
    volume set: success

5、查看upload volume信息。

    $ sudo gluster volume info upload
    Volume Name: upload
    Type: Replicate
    Volume ID: 7d9dac46-20db-4064-9bc5-a2udm0e09527
    Status: Started
    Number of Bricks: 1 x 2 = 2
    Transport-type: tcp
    Bricks:
    Brick1: gfs1:/srv/brick/upload
    Brick2: gfs2:/srv/brick/upload
    Options Reconfigured:
    nfs.disable: true
    performance.readdir-ahead: on
