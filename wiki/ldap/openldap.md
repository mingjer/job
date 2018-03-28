> CentOS release 6.5

一、server

$ yum install openldap-servers.x86_64 openldap-clients.x86_64

$ yum list installed | grep openldap
openldap.x86_64         2.4.40-7.el6_7  @updates
openldap-servers.x86_64 2.4.40-7.el6_7  @updates

$ rpm -ql  openldap-servers | grep slapd.conf
/etc/openldap/slapd.conf
/etc/openldap/slapd.conf.bak
/usr/share/man/man5/slapd-config.5.gz
/usr/share/man/man5/slapd.conf.5.gz
/usr/share/openldap-servers/slapd.conf.obsolete

$  rpm -ql openldap-servers | grep DB_CONFIG
/usr/share/openldap-servers/DB_CONFIG.example

$ cd /etc/openldap/; ls; cp /usr/share/openldap-servers/slapd.conf.obsolete /etc/openldap/slapd.conf
certs  check_password.conf  ldap.conf  schema  slapd.d

$ vi /etc/openldap/slapd.conf

先不考虑TLS证书加密的问题，因此，注释相关配置行：

    ### TLSCACertificatePath /etc/openldap/certs
    ### TLSCertificateFile "\"OpenLDAP Server\""
    ### TLSCertificateKeyFile /etc/openldap/certs/password

保证如下权限配置：

    access to attrs=userPassword   #针对userPassword属性
            by self write          #认证用户自己有写权限，Self service password
            by users read          #认证用户有读权限
            by anonymous auth      #匿名用户需要认证先
    access to *                    #针对其他
            by users read          #认证用户有读权限
            by anonymous auth      #匿名用户需要认证先

修改dc、cn等条目，如：

    by dn.exact="cn=admin,dc=qjdchina,dc=com" read

    database        bdb
    suffix          "dc=qjdchina,dc=com"
    checkpoint      1024 15
    rootdn          "cn=admin,dc=qjdchina,dc=com"
    # rootpw        secret
    # rootpw        {crypt}ijFYNcSNctBYg

设置rootpw

    $ slappasswd
    New password:
    Re-enter new password:
    {SSHA}Sw8vfb7NfPMxPxxxxxx/DU7xxxxxx

    - # rootpw        {crypt}ijFYNcSNctBYg
    + rootpw          {SSHA}Sw8vfb7NfPMxPxxxxxx/DU7xxxxxx


设置Log级别和Limit限制相关内容：

    ##### Log #####
    loglevel        257   #256+1，一般256即可  ##后面(三)会设置log文件
    ##### Limit #####
    #This directive specifies the maximum number of entries to return from a search operation
    sizelimit       500
    # This directive specifies the maximum number of seconds (in real time)
    # slapd will spend answering a search request. If a request is not finished
    # in this time, a result indicating an exceeded timelimit will be returned.
    timelimit       3600
    ##### http://www.openldap.org/doc/admin24/limits.html#Size for paged searches #####
    # limits dn.exact='uid=svnuser,ou=People,dc=qjdchina,dc=com' size.pr=unlimited size.prtotal=unlimited
    limits users size.pr=unlimited size.prtotal=unlimited

设置database directory:

    $ mkdir /home/ldapdata; cp /usr/share/openldap-servers/DB_CONFIG.example /home/ldapdata/DB_CONFIG
    $ chmod 700 /home/ldapdata; chown  ldap.ldap  /home/ldapdata -R
    $ grep set_flags /home/ldapdata/DB_CONFIG
    # Transaction Log settings
    set_lg_regionmax 262144
    set_lg_bsize 2097152
    #set_lg_dir logs
    set_flags DB_LOG_AUTOREMOVE #DB LOG AUTO REMOVE，check it

    - directory       /var/lib/ldap
    + directory       /home/ldapdata

设置index，需要根据实际情况设定：

    # Indices to maintain for this database
    index objectClass                       eq,pres
    index uid,cn,mail                       eq,pres,sub
    ##index uidNumber,gidNumber,loginShell    eq,pres
    ##index uid,memberUid                     eq,pres,sub
    ##index nisMapName,nisMapEntry            eq,pres,sub

$ chown  ldap.ldap /etc/openldap/slapd.conf; slaptest -u
config file testing succeeded

$ cd /etc/openldap/; mv slapd.d slapd.d.old; mkdir slapd.d; chmod 700 slapd.d; chown ldap.ldap slapd.d

$ sudo service slapd restart #可能会报错，说找不到/etc/openldap/slapd.d/下目录/文件

$ slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d
config file testing succeeded

$ chown ldap.ldap slapd.d -R

$ sudo service slapd restart

二、data

$ yum install migrationtools

$ vi /usr/share/migrationtools/migrate_common.ph

    # Default DNS domain
    $DEFAULT_MAIL_DOMAIN = "htrader.cn";
    # Default base
    $DEFAULT_BASE = "dc=qjdchina,dc=com";

$ cd /usr/share/migrationtools/; ./migrate_base.pl > ./base.ldif

> 可以选择生成系统账号./migrate_passwd.pl  /etc/passwd > ./passwd.ldif; ./migrate_group.pl  /etc/group > ./group.ldif

编辑base.ldif，保留需要的条目：

    dn: dc=qjdchina,dc=com
    dc: qjdchina
    objectClass: top
    objectClass: domain

    dn: ou=People,dc=qjdchina,dc=com
    ou: People
    objectClass: top
    objectClass: organizationalUnit

    dn: ou=Group,dc=qjdchina,dc=com
    ou: Group
    objectClass: top
    objectClass: organizationalUnit

$ ldapadd -x  -D 'cn=admin,dc=qjdchina,dc=com' -W  -f base.ldif
Enter LDAP Password:
adding new entry "dc=qjdchina,dc=com"
adding new entry "ou=People,dc=qjdchina,dc=com"
adding new entry "ou=Group,dc=qjdchina,dc=com"

$ ldapsearch  -x -D "cn=admin,dc=qjdchina,dc=com" -b "dc=qjdchina,dc=com" -W #查看已加的条目

1. +people

查看/etc/openldap/schema中的objectclass person/organizationalPerson/inetOrgPerson：

    objectclass ( 2.5.6.6 NAME 'person'
        DESC 'RFC2256: a person'
        SUP top STRUCTURAL
        MUST ( sn $ cn )
        MAY ( userPassword $ telephoneNumber $ seeAlso $ description ) )
    objectclass ( 2.5.6.7 NAME 'organizationalPerson'
        DESC 'RFC2256: an organizational person'
        SUP person STRUCTURAL
        MAY ( title $ x121Address $ registeredAddress $ destinationIndicator $
                preferredDeliveryMethod $ telexNumber $ teletexTerminalIdentifier $
                telephoneNumber $ internationaliSDNNumber $
                facsimileTelephoneNumber $ street $ postOfficeBox $ postalCode $
                postalAddress $ physicalDeliveryOfficeName $ ou $ st $ l ) )
    objectclass     ( 2.16.840.1.113730.3.2.2 NAME 'inetOrgPerson'
        DESC 'RFC2798: Internet Organizational Person'
        SUP organizationalPerson
        STRUCTURAL
        MAY (
                audio $ businessCategory $ carLicense $ departmentNumber $
                displayName $ employeeNumber $ employeeType $ givenName $
                homePhone $ homePostalAddress $ initials $ jpegPhoto $
                labeledURI $ mail $ manager $ mobile $ o $ pager $
                photo $ roomNumber $ secretary $ uid $ userCertificate $
                x500uniqueIdentifier $ preferredLanguage $
                userSMIMECertificate $ userPKCS12 )
        )

$ cat user.ldif

    dn: uid=user1,ou=People,dc=qjdchina,dc=com
    sn: user1
    cn: user1
    uid: user1
    userPassword: user1
    mail: user1@163.com
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson

    dn: uid=user2,ou=People,dc=qjdchina,dc=com
    sn: user2
    cn: user2
    uid: user2
    userPassword: user2
    mail: user2@163.com
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson

    dn: uid=user3,ou=People,dc=qjdchina,dc=com
    sn: user3
    cn: user3
    uid: user3
    userPassword: user3
    mail: user3@163.com
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson

    dn: uid=user4,ou=People,dc=qjdchina,dc=com
    sn: user4
    cn: user4
    uid: user4
    userPassword: user4
    mail: user4@163.com
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson

$ ldapadd -x  -D 'cn=admin,dc=qjdchina,dc=com' -W  -f user.ldif

$ ldapsearch  -x -D "cn=admin,dc=qjdchina,dc=com" -b "ou=People,dc=qjdchina,dc=com" -W #查看已加的条目，用LdapAdmin查看，可以发现用户密码为明文

$ slappasswd -h {SSHA} # or slappasswd -h {SSHA} -s user1

    New password:<user1>
    Re-enter new password:<user1>
    {SSHA}xKrDwP5I8nYDXR+Sr3banxxxxxxxxx

$ ldapmodify -x -D "cn=admin,dc=qjdchina,dc=com"  -W -h LdapServerHostname/IP

    Enter LDAP Password:
    dn: uid=user1,ou=People,dc=qjdchina,dc=com
    changetype: modify
    replace: userPassword  #修改userPassword属性
    userPassword: {SSHA}xKrDwP5I8nYDXR+Sr3banxxxxxxxxx
    <回车键>
    modifying entry "uid=user1,ou=People,dc=qjdchina,dc=com"

$ ldapsearch -x -D "uid=user1,ou=People,dc=qjdchina,dc=com" -b "ou=People,dc=qjdchina,dc=com" -s children -W #查看已加的条目，用LdapAdmin查看，user1用户密码加密

$ ldapmodify -x -D "cn=admin,dc=qjdchina,dc=com" -W -h LdapServerHostname/IP

    Enter LDAP Password:
    dn: uid=user1,ou=People,dc=qjdchina,dc=com
    changetype: modify
    add: registeredAddress  #增加registeredAddress属性
    registeredAddress: 杭州
    <回车键>
    modifying entry "uid=user1,ou=People,dc=qjdchina,dc=com"

2. +group

查看/etc/openldap/schema中的objectclass groupOfUniqueNames|groupOfNames：

    objectclass ( 2.5.6.17 NAME 'groupOfUniqueNames'
        DESC 'RFC2256: a group of unique names (DN and Unique Identifier)'
        SUP top STRUCTURAL
        MUST ( uniqueMember $ cn )
        MAY ( businessCategory $ seeAlso $ owner $ ou $ o $ description ) )
    objectclass ( 2.5.6.9 NAME 'groupOfNames'
        DESC 'RFC2256: a group of names (DNs)'
        SUP top STRUCTURAL
        MUST ( member $ cn )
        MAY ( businessCategory $ seeAlso $ owner $ ou $ o $ description ) )

> **groupOfNames** stores its members in the member attribute (using DN as the value)

> **groupOfUniqueNames** stores its members in the uniquemember attribute (again using DN as value).

> The **uniquemember** attribute however is designed to be able to hold an extra unique identifier to tell the difference between two DN’s who have the same value in a group. The reason why this might happen is that a user is deleted from the directory, but not from all of the groups. Later a new entry is added with the same DN, but it is a different person. This person needs access to the group, but you need a way to differentiate between this recent addition and the earlier DN (if you have several thousand members, simply deleting the earlier DN may not be a reasonable option).

$ cat group.ldif 

    dn: cn=hangzhou,ou=Group,dc=qjdchina,dc=com
    objectClass: top
    objectClass: groupOfUniqueNames
    cn: 杭州
    uniqueMember: uid=user1,ou=People,dc=qjdchina,dc=com
    uniqueMember: uid=user2,ou=People,dc=qjdchina,dc=com

    dn: cn=suzhou,ou=Group,dc=qjdchina,dc=com
    objectClass: top
    objectClass: groupOfUniqueNames
    cn: 苏州
    uniqueMember: uid=user2,ou=People,dc=qjdchina,dc=com
    uniqueMember: uid=user3,ou=People,dc=qjdchina,dc=com

    dn: cn=shaoxing,ou=Group,dc=qjdchina,dc=com
    objectClass: top
    objectClass: groupOfUniqueNames
    cn: 绍兴
    uniqueMember: uid=user3,ou=People,dc=qjdchina,dc=com
    uniqueMember: uid=user4,ou=People,dc=qjdchina,dc=com

$ ldapadd -x  -D 'cn=admin,dc=qjdchina,dc=com' -W  -f group.ldif

$ ldapsearch  -x -D "cn=admin,dc=qjdchina,dc=com" -b "ou=Group,dc=qjdchina,dc=com" -W

三、log

$ vim /etc/rsyslog.d/openldap.conf  #or /etc/rsyslog.conf

    # save OpenLDAP log. Notice /etc/openldap/slapd.conf have define loglevel.
    local4.*   /var/log/slapd/slapd.log

$ mkdir /var/log/slapd; touch /var/log/slapd/slapd.log

$ chown ldap.ldap /var/log/slapd -R

$ service rsyslog restart
