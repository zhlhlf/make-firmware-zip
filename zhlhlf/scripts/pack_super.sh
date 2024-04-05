export PATH=$PATH:$(pwd)
project="project"
DNA_TMP=$project
DNA_PRO=$project

help(){
    echo "输入错误  例如 bash x.sh VAB \"system.img vendor.img\" b"
    echo "           例如 bash x.sh A \"system.img vendor.img\""
    exit 0
}

if [ "aa$1" = "aa" ] || [ "aa$2" = "aa" ];then
        help  
elif [ $1 = "VAB" ];then
    if [ "$3" = "a" ] || [ "$3" = "b" ];then    
        super_size=7516192768  #7*1024*1024*1024
    else 
          help  
    fi
else
    super_size=7516192768  #7*1024*1024*1024
fi
group_size=0
super_group=qti_dynamic_partitions
argvs="--metadata-size 65536 --super-name super "
echo "> 开始合成：super.img"
for i in $2; do
  image=$(echo "$i" | sed 's/.img//g')
  if [ "$1" = "VAB" ] || [ "$1" = "AB" ];then
      img_size=$(du -sb $DNA_PRO/$image.img | awk '{print $1}')
	  group_size=`expr ${img_size} + ${group_size}`
      if [ "$3" = "a" ];then    
    	  argvs+="--partition "$image"_a:none:$img_size:${super_group}_a --image "$image"_a=$DNA_PRO/$image.img --partition "$image"_b:none:0:${super_group}_b "
      elif [ "$3" = "b" ];then    
    	  argvs+="--partition "$image"_b:none:$img_size:${super_group}_b --image "$image"_b=$DNA_PRO/$image.img --partition "$image"_a:none:0:${super_group}_a "
      else
          help  
      fi
  else
      img_size=$(du -sb $DNA_PRO/$image.img | awk '{print $1}')
	  group_size=`expr ${img_size} + ${group_size}`
      argvs+="--partition "$image":none:$img_size:${super_group} --image "$image"=$DNA_PRO/$image.img "
  fi
done

argvs+="--device super:$super_size "
echo "$group_size"
echo "$super_size"
if [ "$1" = "VAB" ] || [ "$1" = "AB" ];then
    argvs+="--metadata-slots 3 "
    argvs+="--group ${super_group}_a:$super_size "
    argvs+="--group ${super_group}_b:$super_size "
else
    argvs+="--metadata-slots 2 "
    argvs+="--group ${super_group}:$super_size "
fi
if [ "$1" = "VAB" ];then
	argvs+="--virtual-ab "
fi
if [ -f "$DNA_PRO/super.img" ];then
  rm -rf $DNA_PRO/super.img
fi
argvs+="-F --output $DNA_PRO/super.img"
if ( lpmake $argvs 2>&1 );then    
    echo "> 打包完成 $DNA_PRO/super.img"
else
    echo "> 打包失败"
fi