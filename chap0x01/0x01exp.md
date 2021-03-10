
# 实验一 Linux基础
---
## 一、实验目的
- 配置无人值守安装iso并在Virtualbox中完成自动化安装。 
- Virtualbox安装Ubuntu后新添加的网卡实现系统开机自动启用和自动获取IP
- 使用sftp在虚拟机和宿主机之间传输文件
---
## 二、实验环境
- MacOS Catalina 10.15.7
- Virtualbox
- Ubuntu 20.04 Server 64bit
---
## 三、实验步骤

### 1.  手动安装Ubuntu20.04

**用户名**：cuc

**NAT**：10.0.2.15

**Host-Only**：192.168.56.103

**确认宿主机可以ssh连接Linux**：
```shell
ssh cuc@192.168.56.103
```

![](./img/ssh-login.jpeg)

### 2. 配置SSH免密登录
1. ssh-keygen生成公钥-私钥对：
```shell
ssh-keygen
```

![](./img/keygen.jpeg)


2. ssh-copy-id配置免密登陆
```shell
ssh-copy-id -i/.ssh/id_rsa.pub cuc@192.168.56.103
```


![](./img/ssh-copyid0.jpeg)
![](./img/ssh-copyid1.jpeg)
---
### 3. 定制无人值守安装镜像iso文件


1. ssh登陆虚拟机创建一个工作目录用于克隆光盘内容
```shell
  mkdir clone

  cat << EOF > ~/clone/meta-data
  instance-id: 1
  local-hostname: cuc-091
  EOF
```
![](./img/make-clone.jpeg)

2. 在虚拟机中制作ISO镜像文件,镜像文件里的文件名必须是**user-data 和 meta-data** 

![](./img/make-iso.jpeg)

3. 获取手动安装Ubuntu后得到的初始「自动配置描述文件」，并将其从虚拟机中**利用sftp方式传输到宿主机中**
```shell
sudo scp cuc@192.168.56.103:/var/log/installer/auoinstaller-userudata ./
```

![](./img/scp-to-host.jpeg)

4. 利用在线文档对比工具Mergly对照老师提供的可用配置文件`user-data`对上述文件进行**酌情修改**

![](./img/compare.jpeg)

5. 将修改后的`autoinstall-user-data`文件**传回虚拟机中**，确认虚拟机已成功接受该文件，将其更名为`user-data`
-  宿主机中
```shell
scp ./autoinstall-user-data cuc@192.168.56.103:~/clone
```
![](./img/scp-to-virtual.jpeg)
- 虚拟机中
```shell
cd clone
mv autoinstall-user-data user-data
```
![](./img/check-clone.jpeg)

6. 利用**sftp传输方式**，宿主机得到包含`user-data`和`meta-data`的ISO镜像文件,假设命名为`091-init.iso`
```shell
sudo scp cuc@192.168.56.103:~/clone/091-init.iso ./
```
![](./img/scp-iso.jpeg)

7. 新建一个名为`091-auto`的虚拟机，移除虚拟机「设置」-「存储」-「控制器：IDE」，并在「控制器：SATA」下新建2个虚拟光盘，**按顺序**先挂载「纯净版Ubuntu安装镜像文件」后挂载`091-init.iso`

![](./img/new-disk.jpeg)
---

### 4. 激动人心的无人值守安装时刻
启动虚拟机，待命令行出现下述内容：
> Continue with autoinstall? (yes|no)

**手动输入yes**并单击回车后静候20分钟左右，程序便自动完成系统安装与重启进入系统的可用状态,完成✅
~~有亿点模糊~~

![](./img/auto-run.GIF)

---
## 四、实验过程中的问题与解决方案
- 使用sftp在宿主机与虚拟机之间进行文件传输时，宿主机中需使用**sudo**启用管理员身份执行指令，否则会报**Permission denied**禁止传输等操作。
---
## 五、参考文献
- <a href="https://www.ssh.com/ssh/keygen/"> How to use ssh-keygen to generate a new SSH key</a>
- <a href="https://www.ssh.com/ssh/copy-id"> ssh-copy-id for coping SSH keys to server</a>
- <a href="https://blog.csdn.net/feinifi/article/details/78213297" target="_blank">ssh-keygen和ssh-copy-id实现免密登录远程主机</a>
- <a href="https://www.cnblogs.com/storyawine/p/13359393.html"> sudo的介绍及基本用法</a>
- <a href="https://www.ssh.com/ssh/sftp/" target="_blank">SFTP File Transfer Protocol - get SFTP client & server</a>
- <a href="https://lmlxj.blog.csdn.net/article/details/80839322?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control&dist_request_id=&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control" target="_blank"> Mac如何使用SSH远程连接linux及使用SFTP进行文件上传、下载</a>
- <a href="https://help.ubuntu.com/community/InstallCDCustomization" target="_blank"> Ubuntu 20.04 + Autoinstall + VirtualBox</a>
- <a href="https://c4pr1c3.gitee.io/linuxsysadmin/exp/chap0x01/cd-rom/nocloud/user-data" target="_blank"> 老师提供的可用配置文件user-data</a>
- <a href="https://c4pr1c3.gitee.io/linuxsysadmin/cloud-init.md" target="_blank"> 第八章Cloud-init内容</a>
- <a href="https://wiki.debian.org/genisoimage" target="_blank"> genisoimage用法</a>
