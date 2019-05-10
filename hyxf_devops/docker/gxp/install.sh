#!/bin/sh

name=gxp
pass=Gaps123!
gxpversinname=GXPP3.1-Linux64-20180706-install.bin

ROOT_UID=0

if [ "$UID" -eq "$ROOT_UID" ]
then
  echo "You are root."
else
  echo "Installation requires root users. Please use root to login"
  exit
fi

ls /home/$name/bin/gxpversion &>/dev/null
  if [ $? -ne 0 ]; then
    echo gxp is not installed yet, starting to install...
  else
    echo gxp already installed,remove gxpversion version.	
	rm -rf /home/$name/.GXPVERSION	&>/dev/null
	
	if [ $? -ne 0 ]; then
		echo gxp is uninstalled success.
	else
		echo gxp is uninstalled fail.
	fi
  fi

rpm -qa | grep ksh &>/dev/null
  if [ $? -ne 0 ]; then
    echo ksh is not installed yet, starting to install...  
    yum install -y ksh
  else
    echo ksh already installed.
  fi

echo "you are setting password : $pass for ${name}"

groupadd $name

if [ $? -eq 0 ];then
   echo "group ${name} is created successfully!!!"
else
   echo "group ${name} is created failly!!!"
fi

useradd -g $name $name

if [ $? -eq 0 ];then
   echo "user ${name} is created successfully!!!"
else
   echo "user ${name} is created failly!!!"
fi

echo $pass | sudo passwd $name --stdin  &>/dev/null
if [ $? -eq 0 ];then
   echo "${name}'s password is set successfully"
else
   echo "${name}'s password is set failly!!!"
fi


getdir=$(pwd)

echo "start install gxp"
echo "export GXPHOME=/home/$name">> /home/$name/.bash_profile

chmod a+x $gxpversinname
chown $name:$name  $gxpversinname



GXPPID=$(ps -ef|grep gxp_datasvr|grep $name|grep -v grep|cut -c 9-15|xargs)
echo "gxpdatasvr is ${GXPPID} "
if [ $GXPPID -eq 0 ];then
   echo "gxpdatasvr is not running!!!"
else
   kill -9 $GXPPID
   sleep 3
   echo "gxpdatasvr is stopped!!!"
fi

su - $name <<EOF

sleep 5
echo "stop gxp_datasvr success"

stopp -f

sleep 5
echo "stop gxp_dm success"


cd $getdir
./$gxpversinname install

echo ". ~/etc/setenv">> /home/$name/.bash_profile

EOF

sleep 6

su - $name <<EOF

cd $getdir

gxp_datasvr

sleep 5

startp

sleep 5

EOF


echo "gxp install success"