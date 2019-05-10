#!/bin/sh

ACCESS_KEY_ID="LTAIsG50V1n75O4i"

ACCESS_KEY_SECRET="QiwqWd3jqPpiS02oYsb4GA0YdIYWZs"

END_POINT="oss-cn-hzfinance.aliyuncs.com"

BUCKET_NAME="prod-core-platform-ali-public"

ossutil64 cp -r $WORKSPACE/dev oss://${BUCKET_NAME}/H5 -f -e ${END_POINT} -i ${ACCESS_KEY_ID} -k ${ACCESS_KEY_SECRET}
