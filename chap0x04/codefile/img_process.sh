#!/usr/bin/env bash

# 对jpeg格式图片进行图片质量压缩
function quality_compress {
    Q=$1 # 质量因子
    for i in *;do
        type=${i##*.} # 获取文件类型
        if [[ ${type} != "jpg" && ${type} != "jpeg" ]]; then continue; fi;
        convert "${i}" -quality "${Q}" "${i}"
        echo "Compressing ${i} -- down."
    done
}

# 对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function distinguish_compress {
    D=$1
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpg" && ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        convert "${i}" -resize "${D}" "${i}"
        echo "Proportional compressing ${i} -- down."
    done
}

# 对图片批量添加自定义文本水印
function watermarking {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpg" && ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        convert "${i}" -pointsize "$1"  -draw "text 0,20 '$2'" "${i}"
        echo "Watermarking ${i} with $2 -- down."
    done
}

# 统一添加文件名前缀,不影响原始文件扩展名）
function add_prefix {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpg" && ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        mv "${i}" "$1""${i}"
        echo "${i} is prefixed as $1${i} -- down."
    done
}

# 统一添加文件名后缀,不影响原始文件扩展名）
function add_postfix {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpg" && ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        newname=${i%.*}$1"."${type}
        mv "${i}" "${newname}"
        echo "${i} is postfixed as ${newname} -- down."
    done
}

# 将png/svg图片统一转换为jpg格式图片
function trans_to_jpg {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        newfile=${i%.*}".jpg"
        convert "${i}" "${newfile}"
   	echo "Transform ${i} to ${newfile} -- down."
    done
}

#help文档
function help {
    echo "-q Q               对jpeg格式图片进行图片质量因子为Q的压缩"
    echo "-d D               对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩成D分辨率"
    echo "-w fontsize watermark_text  对图片批量添加自定义文本水印"
    echo "-p text            统一添加文件名前缀，不影响原始文件扩展名"
    echo "-s text            统一添加文件名后缀，不影响原始文件扩展名"
    echo "-t                 将png/svg图片统一转换为jpg格式图片"
}

#使用0命令行参数方式使用不同功能
while [ "$1" != "" ];do
case "$1" in
    "-q")
        quality_compress "$2"
        exit 0
        ;;
    "-d")
        distinguish_compress "$2"
        exit 0
        ;;
    "-w")
        watermarking "$2" "$3"
        exit 0
        ;;
    "-p")
        add_prefix "$2"
        exit 0
        ;;
    "-s")
        add_postfix "$2"
        exit 0
        ;;
    "-t")
        trans_to_jpg
        exit 0
        ;;
    "-h")
        help
        exit 0
        ;;
esac
done

