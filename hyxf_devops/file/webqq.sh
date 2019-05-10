#!/bin/bash

#获取Jenkins API
curl -s -o .temp.xml "$BUILD_URL/api/xml" --user guojx:118e1cd6ea22bff3c45b8373ab1ed86c65 >/dev/null

action=`cat .temp.xml | xml2 | grep /freeStyleBuild/action/cause/shortDescription= | awk -F= '{print $2}'`
build_status=`cat .temp.xml | xml2 | grep /freeStyleBuild/result= | awk -F= '{print $2}'`
developer=`cat .temp.xml | xml2 | grep /freeStyleBuild/culprit/fullName= | awk -F= '{print $2}'`

notices="#### Jenkins构建结果  \n > Job: <$BUILD_URL/console>\n\n > Action: $action\n\n  > Operator: $operate_user\n\n  > Developer: $developer\n\n  > Status: $build_status\n\n  >Jenkins.\n"

subject=`echo "Jenkins构建结果" | tr '\r\n' '\n'`
body=`echo $notices | tr '\r\n' '\n'`

#钉钉发送通知
curl 'https://oapi.dingtalk.com/robot/send?access_token=b9750d1f024b3b14dd3ad33f46a53458ba7f224e477f3f334fd19878e0f063b6' \
   -H 'Content-Type: application/json' \
   -d """
 {
     \"msgtype\": \"markdown\",
     \"markdown\": {
         \"title\":\"${subject}@18******5\",
         \"text\": \"${body}\"
     },
    \"at\": {
        \"atMobiles\": [ 
            \"18*******5\",
        ], 
        \"isAtAll\": false
    }
 }"""

##清理现场
rm -rf .temp.xml .groupinfojson temp.xml groupinfojson
