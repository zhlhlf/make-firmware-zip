cd /data/tmp

package_extract_file(){
    dd if=$1 of=$2 bs=4K
}

log(){
  echo "$1"
  echo "$1" >> /sdcard/zhlhlf_scripts.log  
}

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

images_x = 1

images_exist(){
    for i in `echo $1 | cut -d' ' -f1-*`
    do
        i=$(basename $i .img)
        if [ ! -f "project/${i}.img"  ];then
            log "project/${i}.img 不存在"
            images_x=0
        fi
    done
}

flash_images(){
    for i in $list
    do
        package_extract_file project/${i}.img /dev/block/by-name/${i}_$1
    done
    bash pack_super.sh VAB "$list_super" $1
    if [ -f project/super.img ];then
        package_extract_file project/super.img /dev/block/by-name/super
        exit 1
    else
        log "生成super失败"
        exit 0
    fi
}

echo "author zhlhlf"
#验证是否存在需要的镜像
images_exist "$list"
images_exist "$list_super"

if [ $images_x == "0" ];then
    log "images不完整 无法继续操作"
    exit 0
fi

log "flash_images -> $1"

flash_images $1



