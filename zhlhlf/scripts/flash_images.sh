cd /data/tmp

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

package_extract_file(){
    dd if=$1 of=$2 bs=4K
}


hh=$(keyListener)

if [ $hh = 1 ];then
  ab=0
elif [ $hh = 0 ];then
  ab=1
fi

chmod 777 * -R
pwd
ls
mv images project

    
    list="boot dtbo vbmeta vbmeta_system"
    if [ -f project/my_stock.img ];then
        list_super="odm.img product.img vendor.img system.img system_ext.img my_company.img my_preload.img my_engineering.img my_product.img my_bigball.img my_heytap.img my_region.img my_carrier.img my_manifest.img my_stock.img"
    else
        list_super="odm.img product.img vendor.img system.img system_ext.img"
    fi
        
    if [ $ab = "1" ];then
        
        bash pack_super.sh VAB "$list_super" b 
        for i in $list
        do
            
            package_extract_file project/${i}.img /dev/block/by-name/${i}_b         
            rm -rf project/${i}.img
        done
    elif [ $ab = "0" ];then
        
        bash pack_super.sh VAB "$list_super" a 
        for i in $list
        do
            
            package_extract_file project/${i}.img /dev/block/by-name/${i}_a
            rm -rf project/${i}.img
        done
    fi
    if [ -f project/super.img ];then    
        
        package_extract_file project/super.img /dev/block/by-name/super     
        return 1        
    else
        return 0
    fi
    

