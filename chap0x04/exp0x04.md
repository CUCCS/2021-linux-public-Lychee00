# 实验四：shell脚本编程练习基础
## 一、实验环境
- MacOS Catalina 10.15.7
- Virtualbox
- Ubuntu 20.04 Server 64bit
## 二、编程任务
### 任务一：用bash编写一个图片批处理脚本，实现以下功能：
- ☑️支持命令行参数方式使用不同功能
- ☑️支持对指定目录下所有支持格式的图片文件进行批处理指定目录进行批处理
- ☑️支持以下常见图片批处理功能的单独使用或组合使用
    - ☑️支持对jpeg格式图片进行图片质量压缩
    - ☑️支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
    - ☑️支持对图片批量添加自定义文本水印
    - ☑️支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
    - ☑️支持将png/svg图片统一转换为jpg格式
### 任务二：用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
- ☑️统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
- ☑️统计不同场上位置的球员数量、百分比
- ☑️名字最长的球员是谁？名字最短的球员是谁？
- ☑️年龄最大的球员是谁？年龄最小的球员是谁？

### 任务三：用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
- ☑️统计访问来源主机TOP 100和分别对应出现的总次数
- ☑️统计访问来源主机TOP 100 IP和分别对应出现的总次数
- ☑️统计最频繁被访问的URL TOP 100
- ☑️统计不同响应状态码的出现次数和对应百分比
- ☑️分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
- ☑️给定URL输出TOP 100访问来源主机

## 三、实验要求
- 所有源代码文件必须单独提交并提供详细的```-help```脚本内置帮助信息
- 任务三的所有统计数据结果要求写入独立实验报告

## 四、实验步骤
**详细实验结果可在[Travis](https://www.travis-ci.com/github/Lychee00/shellbank/builds/223608246)中查看**
### 任务一
- 安装```imagemagick```和```shellcheck```。
```bash
sudo apt-get update && sudo apt-get install -y shellcheck
sudo apt-get install -y imagemagick
```
- 将文件下载到本地
```bash
wget "https://c4pr1c3.gitee.io/linuxsysadmin/exp/chap0x04/worldcupplayerinfo.tsv"
```
- 编写脚本 
```shell
#-help脚本内置帮助信息
    -q Q               对jpeg格式图片进行图片质量因子为Q的压缩
    -d D               对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩成D分辨率
    -w fontsize watermark_text  对图片批量添加自定义文本水印
    -p text            统一添加文件名前缀，不影响原始文件扩展名
    -s text            统一添加文件名后缀，不影响原始文件扩展名
    -t                 将png/svg图片统一转换为jpg格式图片
```
- 测试结果 
![](/img/img_process.png)
### 任务二
- 将所需文件下载到本地，并使用sftp将文件传至虚拟机
- 编写脚本 
```shell
#-help脚本内置帮助信息
    -s                 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
    -c                 统计不同场上位置的球员数量、百分比
    -l                 名字最长的球员是谁？名字最短的球员是谁？
    -a                 年龄最大的球员是谁？年龄最小的球员是谁？
```
- 测试结果 
![](/img/statistics_player.jpeg)

### 任务三
- 安装 p7zip-full
```bash
sudo apt-get install p7zip-full
```
- 将文件下载到本地并解压
```bash
wget "https://c4pr1c3.gitee.io/linuxsysadmin/exp/chap0x04/web_log.tsv.7z"

7z x web_log.tsv.7z
```

- 编写脚本 
```shell
#-help脚本内置帮助信息
    -o      统计访问来源主机TOP 100和分别对应出现的总次数
    -i      统计访问来源主机TOP 100 IP和分别对应出现的总次数
    -u      统计最频繁被访问的URL TOP 100
    -s      统计不同响应状态码的出现次数和对应百分比
    -f      分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
    -g URL  给定URL输出TOP 100访问来源主机
```
- 测试结果
![](/img/statistics_top100.jpeg)

## 五、问题及解决方法
1. 任务1子任务：支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率时，编写的函数为
```shell
  function distinguish_compress {
    D=$1
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpg" && ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        convert "${i}" -resize "${D}" "${i}"
        echo "Proportional compressing ${i} -- down."
    done
}
```
执行命令
```shell
cuc@lychee:~/task1$ bash img_process.sh -d 70
```
对于jpeg图片和png图片处理成功，而对于svg图片处理失败，报以下错误：
```bash
convert-im6.q16: Unescaped '<' not allowed in attributes values
 `No such file or directory` @ error/svg.c/SVGError/2998.
convert-im6.q16: attributes construct error
 `No such file or directory` @ error/svg.c/SVGError/2998.
convert-im6.q16: error parsing attribute name
 `No such file or directory` @ error/svg.c/SVGError/2998.
convert-im6.q16: attributes construct error
 `No such file or directory` @ error/svg.c/SVGError/2998.
convert-im6.q16: xmlParseStartTag: problem parsing attributes
 `No such file or directory` @ error/svg.c/SVGError/2998.
convert-im6.q16: Couldn't find end of Start Tag g
 `No such file or directory` @ error/svg.c/SVGError/2998.
convert-im6.q16: no images defined `sharefood.svg' @ error/convert.c/ConvertImageCommand/3258.
Proportional compressing sharefood.svg -- down.
```
但在trarvis中成功运行并无报错

## 六、参考资料
- [Linux wget命令详解 wget下载工具用法详解](https://blog.csdn.net/qq_31705033/article/details/84728174)
- [ImageMagick官方文档](https://imagemagick.org/)
- [linux命令--查找与统计（grep、awk、sort、uniq、wc）](https://blog.csdn.net/hshuihui/article/details/77915398)
- [awk 入门教程](http://www.ruanyifeng.com/blog/2018/11/awk.html)
- [awk命令](https://man.linuxde.net/awk)
- [持续集成服务 Travis CI 教程](http://www.ruanyifeng.com/blog/2017/12/travis_ci_tutorial.html)
- [CUCCS/linux-2019-DcmTruman](https://github.com/CUCCS/linux-2019-DcmTruman/tree/0x04)
- [CUCCS/linux-2020-WOC-BUG](https://github.com/CUCCS/linux-2020-WOC-BUG/tree/0x04/0x04)
