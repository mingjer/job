FROM docker.51xf.cn/centos/centos:7
MAINTAINER WangXiangYang <wangxiangyang@51xf.cn>

ENV GXPHOME=/home/gxp

RUN set -xe \
&& yum -y install net-tools vim wget telnet curl rsync less perl ksh \
&& yum clean all \
&& ln -snf /usr/lib64/libssl.so.1.0.2k /usr/lib64/libssl.so.1.0.0 \
&& ln -snf /usr/lib64/libcrypto.so.1.0.2k /usr/lib64/libcrypto.so.1.0.0

COPY ./install.sh ./GXPP3.1-Linux64-20180706-install.bin /opt/

RUN set -xe \
&& useradd gxp \
&& echo 'Gaps123!' | passwd gxp --stdin &>/dev/null \
&& chown gxp:gxp -R /opt/

WORKDIR /opt/

#RUN nohup ./install.sh &

EXPOSE 55555 12300
