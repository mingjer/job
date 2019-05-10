由于gxp的特殊性，目前只能算是半docker化。
使用方法:
1.首先启动一个docker容器：
docker run -dit --name gxp -p 35555:55555 -p 32300:12300 docker.51xf.cn/51xf/gxp

注意端口根据实际情况进行修改

2.进入docker容器
docker exec -it gxp bash

3.在容器内启动gxp：
nohup ./install.sh &