#!/bin/bash

FNAME=Contacts

mkdir -p $FNAME

function gen() {
qrencode -o $FNAME/$3.png <<EOF
BEGIN:VCARD
N:$1
TEL:$2
EMAIL:$3@htrader.cn
END:VCARD
EOF
cat >>$FNAME.rst <<EOF
   * - $1
     - .. image:: $FNAME/$3.png
     - $2
     - $3@htrader.cn
EOF
}

cat > $FNAME.rst <<EOF
联系方式
================
.. list-table::
   :header-rows: 1
   :widths: 3 5 5 10

   * - 姓名
     - 二维码
     - 电话
     - 邮箱
EOF

gen hanhao 18506856756 hanhao
gen wangxy 18768448903 wangxy
