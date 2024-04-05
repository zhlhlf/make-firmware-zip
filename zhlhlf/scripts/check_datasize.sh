#判断data是否挂载成功能否有足够大小存放解包出来的images
datasize=$(df -h /data | grep /dev/block | awk '{print $4}')
if [ `echo $datasize | sed s/[[:digit:]]//g` = "G" ] && [ `echo $datasize | sed s/G//g` -gt 20 ];then
    return 1
else
    return 0
fi