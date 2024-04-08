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

log(){
  echo "$1"
  echo "$1" >> /sdcard/zhlhlf_scripts.log  
}

get_ddr(){
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
      log "判断你的手机ddr_type失败"
      exit 0
  fi
    
  #把获取的ddr_type写入文件   用于里层刷机脚本获取
  echo "ddr=$hh" >> /data/tmp/type_zhlhlf
  
}

fw_ab(){
  hh=$(keyListener)
  if [ $hh = 1 ];then
    fw=_a
  elif [ $hh = 0 ];then
    fw=_b
  fi
  #把获取的a或者b写入文件   用于里层刷机脚本获取
  echo "fw=$fw" >> /data/tmp/type_zhlhlf
}

is_flash_rom(){
  cd /data/tmp
  if [ ! -d "images" ];then
    echo "不存在images目录，跳过刷rom"
    exit 0
  else
    exit 1
  fi
}

check_datasize(){
  #判断data是否挂载成功能否有足够大小存放解包出来的images
  datasize=$(df -h /data | grep /dev/block | awk '{print $4}')
  if [ `echo $datasize | sed s/[[:digit:]]//g` = "G" ] && [ `echo $datasize | sed s/G//g` -gt 20 ];then
      exit 1
  else
      log "data分区大小错误，需要自行格式化data分区"
      exit 0
  fi
}

rom_ab(){
  hh=$(keyListener)
  if [ $hh = 1 ];then
    ab=a
  elif [ $hh = 0 ];then
    ab=b
  fi
  echo "rom=$ab" >> /data/tmp/type_zhlhlf
  exit 1
}

echo "author zhlhlf"
if [ $1 == "1" ];then
  rm -rf /data/tmp/type_zhlhlf
  fw_ab
  get_ddr
  exit 1
elif [ $1 == "2" ];then
  is_flash_rom 
elif [ $1 == "3" ];then
  check_datasize
elif [ $1 == "4" ];then
  rom_ab
fi
