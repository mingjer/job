#!/bin/sh
#########################################################################
# Author: xiezhifu
# Email: xiezhifu@gmail.com
# Created Time: 2017-02-24
#########################################################################
# Functions: 发送消息到微信应用
###############################

SHORT_OPTION="-o h,V"
LONG_OPTION="-l cropid:,secret:,appid:,partyid:,userid:,subject:,message:,help,version"

version() {
echo Version 1.0
exit 0
}

usage() {
echo wechat.sh [option]
echo 选项：
echo     --cropid	微信cropid
echo     --secret	微信secret
echo     --appid	微信应用ID
echo     --partyid	接收信息用户所在部门ID
echo     --userid	接受信息微信用户名
echo     --subject	发送信息主题
echo     --message	发送信息主题
echo -h, --help	显示帮助信息
echo -V, --version	输出版本信息
exit 0
}

ARGS=`getopt $SHORT_OPTION $LONG_OPTION -- "$@"`
[ $? -ne 0 ] && usage
eval set -- "$ARGS"

while true
do
	case "$1" in
	--cropid)
		CROPID="$2"
		shift
		;;
	--secret)
		SECRET="$2"
		shift
		;;
	--appid)
		APPID="$2"
		shift
		;;
	--partyid)
		PARTYID="$2"
		shift
		;;
	--userid)
		USERID="$2"
		shift
		;;
	--subject)
		SUBJECT="$2"
		shift
		;;
	--message)
		MESSAGE="$2"
		shift
		;;
	-h|--help)
		usage
		;;
	-V|--version)
		version
		;;
	--)
		shift
		break
		;;
	*)
		echo "输入的参数错误!"
		exit 1
		;;
	esac 
shift
done

get_token() {
    GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CROPID&corpsecret=$SECRET"
    token_expires_time=0
    token=
    current_time=$(date +"%s")
    token_new_expires_time=$(date +"%s" -d"2 hour")
    if [ -f /tmp/wechat.tmp ]; then
        token_expires_time=$(cat /tmp/wechat.tmp | awk -F: '{print $1}')
        token=$(cat /tmp/wechat.tmp | awk -F: '{print $2}')
    fi
    if [ $token_expires_time -gt $current_time ]; then
        echo $token
    else
        token=$(/usr/bin/curl -s -G $GURL | jq -r .access_token)
        echo $token_new_expires_time:$token > /tmp/wechat.tmp
        echo $token
    fi
}

msg_body() {
    printf "%s" "{"
    if [ $USERID ]; then
    printf "\t%s\n" "\"touser\":\"$USERID\","
    else
    printf "\t%s\n" "\"touser\":\"@all\","
    fi
    if [ $PARTYID ]; then
    printf "\t%s\n" "\"toparty\":\"$PARTYID\","
    fi
    printf "\t%s\n" '"msgtype":"text",'
    printf "\t%s\n" "\"agentid\":\"$APPID\","
    printf "\t%s\n" "\"text\": {"
    printf "\t\t%s\n\n%s\n" "\"content\":\"$SUBJECT" "$MESSAGE\""
    printf "\t%s\n" "},"
    printf "\t%s\n" "\"safe\":\"0\""
    printf "%s" "}"
}


####################################################
#  debug
#####################################################
# echo "cropid:$CROPID" >> /tmp/zabbix_webchat.log
# echo "secret:$SECRET" >> /tmp/zabbix_webchat.log
# echo "appid:$APPID" >> /tmp/zabbix_webchat.log
# echo "partyid:$PARTYID" >> /tmp/zabbix_webchat.log
# echo "userid:$USERID" >> /tmp/zabbix_webchat.log
# echo "subject:$SUBJECT" >> /tmp/zabbix_webchat.log
# echo "message:$MESSAGE" >> /tmp/zabbix_webchat.log
# echo "send_param:$(msg_body)" >> /tmp/zabbix_webchat.log
#####################################################

GTOKEN=$(get_token)
PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$GTOKEN"
/usr/bin/curl --data "$(msg_body)" $PURL
