# Gerrit 使用入门

## 通用部分

### 1、登录

Gerrit使用Ldap账号登录。第一次登录之后，需由管理员或超级管理员添加用户到对应的组。如dev-admin组内的管理员可以添加、删除用户到dev-admin或dev组。

### 2、查看自己所属的组

点击左上角`My`-->`Groups`，或直接点击右上角的用户名称，弹出框中的`Settings`进入用户设置页面查看。

### 3、用户设置

进入用户设置页面后，由于Ldap中已经有用户名、邮箱地址等信息，用户无需再次设置。除了查看Group信息，用户一般关注下面几项。

**SSH Public Keys**：上传SSH公钥Key，可以上传多个，用于git ssh协议的认证，推荐使用。

**HTTP Password**: git http协议认证，可以生成或清除随机密码，在无法使用ssh协议时可使用。

**Watched Projects**: 关注项目仓库，设置Watch后，在仓库有变更或其他特定情况时，邮件通知用户。

### 4、查看工程

点击左上角`Projects`-->`List`，可以在`Filter`框中搜索过滤。

  ![projects](Use/projects.jpg)

点击项目名称可进入对应查看页面，这里以`Dev/test`为例。页面上方会出现`General`、`Branches`、`Tags`、`Access`等选项，也会给出仓库clone地址，可选择`Clone with commit-msg hook`，一般使用ssh协议。

  ![project](Use/project.jpg)

Gerrit支持gitweb，点击项目名称右边的`(gitweb)`进入。页面上方会出现`summary`、`log`、`commitdiff`、`tree`等选项，同样提供http、ssh协议项目clone地址，这里也提供shortlog信息。

  ![gitweb](Use/gitweb.jpg)

### 5、Review记录

点击左上角`All`，`Open`为目前未操作过的Review记录，`Merged`为已提交合并到远程仓库的Review记录，`Abandoned`为拒绝掉的Review记录。Review记录形式如下，有`提交主题`、`提交作者`、`项目名称`、`提交到的分支`等信息。

  ![review](Use/review.jpg)

点击`Subject`中的一个记录，进入Review记录操作界面。页面中`Files`部分为修改的文件列表，点击对应文件名称，可以查看修改内容的diff。提交作者可以通过本页面上的`Abandon`按钮，拒绝掉自己的Review提交记录。

  ![change](Use/change.jpg)

点击页面右侧的`Add...`，出现如下界面。在输入框中输入其他用户账号名，可以将对应账号`Add`加入到`Reviewers`中，触发邮件通知其对代码进行review或投票。

  ![change](Use/AddReviewer.jpg)

点击页面上方`Reply`，出现如下界面，用户可以在文本框中对Reivew变更记录填写自己的看法，并进行投票。`+1`表示赞成合并，但需要其他人进一步确认，`-1`不表示不赞同，投票只是表达用户意见。只有项目Owner进行`+2`确认，以及`+1`验证（Verified）后，Review记录才可以合并到远程仓库。

  ![reply](Use/reply.jpg)

## 管理员（Owner）部分

### 1、审核Review记录

管理员Review记录操作上方`Reply`界面和普通用户稍有不同，进行`+2`确认，以及`+1`验证（Verified），`Post`之后，界面上会出现`Submit`按钮，点击`Submit`按钮，Review记录则合并到远程仓库。

  ![ownereply](Use/ownereply.jpg)

### 2、通过页面新建、删除分支

左上角`Projects`-->`List`，并选择、点击进入到一个项目管理界面后，点击页面上方出现的`Branches`，则可以通过界面增加、删除远程仓库的分支，分支名称自定。当然，项目管理员也可以在本地新加好分支，通过推送的方式实现远程仓库分支的增加。

  ![branch](Use/branch.jpg)

### 3、用户组管理

左上角`People`-->`List Groups`，选择、点击`dev`组，进如`dev`组管理界面，项目管理员可以增加、删除组成员。

  ![group2](Use/group2.jpg)

在左侧选择`General`，则可以看到`dev`组是被`dev-admin`组管理的。选择`Audit log`则可以看到组员变动的日志信息。

  ![group1](Use/group1.jpg)

### 4、项目权限管理

左上角`Projects`-->`list`，选择对应的git仓库，然后点击左上角`Access`选项，即是权限设置页面。请[熟悉Gerrit权限控制体系并设置相应权限。](http://wiki.htrader.cn/Git/gerrit/AccessControls)


> 新建git工程/仓库和新建用户组，请提供详细信息，发送邮件到ops@htrader.cn申请。
