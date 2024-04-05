keyListener() {
  key=$(getevent -qlc 1 2>&1 | grep VOLUME | grep " DOWN" | awk '{print $3}')
  if [ $key = "KEY_VOLUMEUP" ]; then
    echo "1"
    return "1"
  elif [ $key = "KEY_VOLUMEDOWN" ]; then
    echo "0"
    return "0"
  else 
    keyListener
  fi
}

#判断ddr类型
if [ "$(cat /proc/devinfo/ddr_type | grep -i DDR4)" ];then
    hh=ddr4
elif [ "$(cat /proc/devinfo/ddr_type | grep -i DDR5)" ];then
    hh=ddr5
elif [ "$(getprop ro.boot.ddr_type | grep -i 0)" ]; then
    hh=ddr4
elif [ "$(getprop ro.boot.ddr_type | grep -i 1)" ]; then
    hh=ddr5
else
    reboot recovery
fi

_ab=$(keyListener)
if [ $_ab = 1 ];then
  _ab=a
elif [ $_ab = 0 ];then
  _ab=b
fi
    
#把获取的ddr_type写入文件   用于里层刷机脚本获取
echo "ddr=$hh" > /data/tmp/type_zhlhlf

#把获取的a或者b写入文件   用于里层刷机脚本获取
echo "ab=_$_ab" >> /data/tmp/type_zhlhlf



