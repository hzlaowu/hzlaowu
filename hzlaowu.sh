#! /bin/bash
# By hzlaowu

#颜色
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}

# check root
#[[ $EUID -ne 0 ]] && echo -e "${red}错误: ${plain} 必须使用root用户运行此脚本！\n" && exit 1
[[ $EUID -ne 0 ]] && echo -e && red "错误: 必须使用root用户运行此脚本！" && exit 1

#服务器检查项目
#VPS综合性能测试脚本
function vpstest(){
    wget -O  vpstest.sh  "https://raw.githubusercontent.com/AlexWu2022/hzlaowu/master/vpstest.sh"
    chmod +x "vpstest.sh"
    yellow "下载完成,之后可执行 bash ./vpstest.sh 再次运行"
    bash vpstest.sh
}


#获取本机IP
function getip(){
    echo  
    curl ip.p3terx.com
    echo
}

#流媒体解锁测试
function MediaUnlock_Test(){
    if [ -e "/etc/redhat-release" ];then
	yellow "新系统需要安装curl，耐心等待吧"
	yum update -y && yum install curl -y
	yum install epel-release
    yum install -y jq
	bash <(curl -sSL "https://github.com/CoiaPrant/MediaUnlock_Test/raw/main/check.sh")
	elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]] || [[ $(cat /etc/os-release | grep '^ID=') =~ debian ]];then
	yellow "新系统需要安装curl，耐心等待吧"
	apt-get update -y && apt-get install curl -y
	apt install -y jq
	bash <(curl -sSL "https://github.com/CoiaPrant/MediaUnlock_Test/raw/main/check.sh")
	else 
	echo -e "${Font_yellow}自动安装失败，请手动安装wget${Font_Suffix}"
	exit
	fi
}

#Netflix_Test
function Netflix_Test(){
    wget -O nf https://github.com/sjlleo/netflix-verify/releases/download/2.6/nf_2.6_linux_amd64 && chmod +x nf && clear && ./nf
}

#Install_wget/curl
function Install_wget/curl(){
	if [ -e "/etc/redhat-release" ];then
	yum update && yum install wget curl -y;
	elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]] || [[ $(cat /etc/os-release | grep '^ID=') =~ debian ]];then
	apt-get update && apt-get install wget curl -y;
	else 
	echo -e "${Font_yellow}请手动安装wget、curl${Font_Suffix}";
	exit;
	fi
}

#Oracle_Firewall
function Oracle_Firewall(){
	if [ -e "/etc/redhat-release" ];then
	yellow "CentOS系统删除多余附件"
	sleep 1s;
    systemctl stop oracle-cloud-agent;
    systemctl disable oracle-cloud-agent;
    systemctl stop oracle-cloud-agent-updater;
    systemctl disable oracle-cloud-agent-updater;
    yellow "停止firewall"
	sleep 1s;
    systemctl stop firewalld.service;
	sleep 1s;
    yellow "禁止firewall开机启动"
	sleep 1s;
    systemctl disable firewalld.service;
	elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]] || [[ $(cat /etc/os-release | grep '^ID=') =~ debian ]];then
	yellow "关闭Oracle自带的Ubuntu镜像默认Iptable规则，并重启服务器"
	sleep 1s;
	sudo iptables -P INPUT ACCEPT;
    sudo iptables -P FORWARD ACCEPT;
    sudo iptables -P OUTPUT ACCEPT;
    sudo iptables -F;
    yellow "关闭Oracle自带的Ubuntu镜像默认Iptable规则，并重启服务器"
	sleep 1s;
    sudo apt-get purge netfilter-persistent;
    sudo reboot;
	#或者强制删除rm -rf /etc/iptables && reboot
    else 
	echo -e "${Font_yellow}请手动设置防火墙${Font_Suffix}";
	exit;
	fi
}

#Oracle_root_passwd
function Oracle_root_passwd(){
    sudo lsattr /etc/passwd /etc/shadow
    sudo chattr -i /etc/passwd /etc/shadow
    sudo chattr -a /etc/passwd /etc/shadow
    sudo lsattr /etc/passwd /etc/shadow

    read -p "自定义ROOT密码:" passwd
    echo root:$passwd | sudo chpasswd root
    sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
    sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
    sudo service sshd restart
    sudo reboot
}

#服务器功能调试
#安装BBR加速
function Linux-NetSpeed(){
    yellow "下载完成后,你可以输入 bash tcp.sh 来手动运行或使用 ./tcp.sh 再次运行BBR加速脚本"
    wget  -N  --no-check-certificate "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh"
    sleep 2s
    chmod +x "tcp.sh"
    yellow "下载完成,马上运行BBR加速脚本"
    bash "./tcp.sh"
}

#ChangeSource Linux换源脚本·下载
function cssh(){
    wget -O "/root/changesource.sh" "https://raw.githubusercontent.com/Netflixxp/jcnf-box/master/sh/changesource.sh" --no-check-certificate -T 30 -t 5 -d
    chmod +x "/root/changesource.sh"
    chmod 777 "/root/changesource.sh"
    yellow "下载完成"
    echo
    yellow "请自行输入下面命令切换对应源"
    blue  " =================================================="
    echo
    green " bash changesource.sh 切换推荐源 "
    green " bash changesource.sh cn  切换中科大源 "
    green " bash changesource.sh aliyun 切换阿里源 "
    green " bash changesource.sh 163 切换网易源 "
    green " bash changesource.sh aws 切换AWS亚马逊云源 "
    green " bash changesource.sh restore 还原默认源 "
}

#IPV.SH ipv4/6优先级调整
function ipvsh(){
    wget -O "/root/ipv4.sh" "https://raw.githubusercontent.com/Netflixxp/jcnf-box/master/sh/ipv4.sh" --no-check-certificate -T 30 -t 5 -d
    chmod +x "/root/ipv4.sh"
    chmod 777 "/root/ipv4.sh"
    yellow "下载完成,之后可执行 bash /root/ipv4.sh 再次运行"
    bash "/root/ipv4.sh"
}

#SWAP一键安装/卸载脚本
function swapsh(){
    wget -O "/root/swap.sh" "https://raw.githubusercontent.com/Netflixxp/jcnf-box/master/sh/swap.sh" --no-check-certificate -T 30 -t 5 -d
    chmod +x "/root/swap.sh"
    chmod 777 "/root/swap.sh"
    yellow "下载完成,你也可以输入 bash /root/swap.sh 来手动运行"
    bash "/root/swap.sh"
}

#系统网络配置优化
function system-best(){
	sed -i '/net.ipv4.tcp_retries2/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
	sed -i '/fs.file-max/d' /etc/sysctl.conf
	sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
	sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
	sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
	sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf

    echo "net.ipv4.tcp_retries2 = 8
    net.ipv4.tcp_slow_start_after_idle = 0
    fs.file-max = 1000000
    fs.inotify.max_user_instances = 8192
    net.ipv4.tcp_syncookies = 1
    net.ipv4.tcp_fin_timeout = 30
    net.ipv4.tcp_tw_reuse = 1
    net.ipv4.ip_local_port_range = 1024 65000
    net.ipv4.tcp_max_syn_backlog = 16384
    net.ipv4.tcp_max_tw_buckets = 6000
    net.ipv4.route.gc_timeout = 100
    net.ipv4.tcp_syn_retries = 1
    net.ipv4.tcp_synack_retries = 1
    net.core.somaxconn = 32768
    net.core.netdev_max_backlog = 32768
    net.ipv4.tcp_timestamps = 0
    net.ipv4.tcp_max_orphans = 32768
# forward ipv4
#net.ipv4.ip_forward = 1">>/etc/sysctl.conf
    sysctl -p
	echo "*               soft    nofile           1000000
    *               hard    nofile          1000000">/etc/security/limits.conf
	echo "ulimit -SHn 1000000">>/etc/profile
	read -p "需要重启VPS后，才能生效系统优化配置，是否现在重启 ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
		echo -e "${Info} VPS 重启中..."
		reboot
	fi
}

#宝塔面板 官方版·一键安装
function bt(){
    if [ -e "/etc/redhat-release" ];then
	yellow "Centos安装宝塔脚本正在运行"
    yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
    elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]];then
	yellow "Ubuntu安装宝塔脚本正在运行"
	wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
	#或者强制删除rm -rf /etc/iptables && reboot
    else 
	yellow "Debian安装宝塔脚本正在运行"
	wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh
	exit;
	fi
}

#解除宝塔面板的强制绑定手机
function btsj(){
    sudo sed -i "s|bind_user == 'True'|bind_user == 'XXXX'|" /www/server/panel/BTPanel/static/js/index.js;
	red "运行完毕以后，请 清除浏览器缓存 并刷新宝塔面板！!"
	sleep 3s
	clear
}


#科学上网工具
#v2-ui.sh 一键安装
function v2-ui(){
    bash <(curl -Ls https://blog.sprov.xyz/v2-ui.sh)
}

#xray.sh xray一键安装八合一
function xray(){
    wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

#wulabing.sh wulabingxray安装脚本
function wulabing(){
    wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontent.com/wulabing/Xray_onekey/main/install.sh" && chmod +x install.sh && bash install.sh
}

#MTP&TLS 一键脚本
function mtp(){
    wget -O "/root/mtp.sh" "https://raw.githubusercontent.com/sunpma/mtp/master/mtproxy.sh" --no-check-certificate -T 30 -t 5 -d
    chmod +x "/root/mtp.sh"
    chmod 777 "/root/mtp.sh"
    yellow "下载完成，你也可以输入 bash /root/mtp.sh 来手动运行"
    bash "/root/mtp.sh"
}

#iptables.sh iptable中转
function iptsh(){
    wget -O "/root/iptables.sh" "https://raw.githubusercontent.com/Netflixxp/jcnf-box/main/sh/iptables.sh" --no-check-certificate -T 30 -t 5 -d
    chmod +x "/root/iptables.sh"
    chmod 777 "/root/iptables.sh"
    yellow "下载完成，你也可以输入 bash /root/iptables.sh 来手动运行"
    bash "/root/iptables.sh"
}

#gost.sh gost一键中转
function gost(){
    wget -O "/root/gost" "https://raw.githubusercontent.com/KANIKIG/Multi-EasyGost/master/gost.sh" --no-check-certificate -T 30 -t 5 -d
    chmod +x "/root/gost.sh"
    chmod 777 "/root/gost.sh"
    yellow "下载完成，你也可以输入 bash /root/gost.sh 来手动运行"
    bash "/root/gost.sh"
}

#主菜单
function start_menu(){
    clear
    red   "                 hzlaowu 常用脚本包" 
    blue  " ======================================================== "
    green " 本脚本支持：CentOS7+ / Debian9+ / Ubuntu16.04+"
	green " 此脚本源于网络，只是汇聚脚本功能，仅做测试使用而已！"
	blue  " ======================================================== "
	
	blue  " =======服务器检查======================================= "
    green "  1. VPS综合性能测试脚本"
    green "  2. 获取本机IP"                      
    green "  3. 流媒体解锁测试"                          
    green "  4. Netflix_Test" 
    green "  5. Install_wget/curl"
    green "  6. Oracle_Firewall"
	green "  7. Oracle_root_passwd"
    	
    blue  " =======服务器功能======================================= "
    green " 11. 安装BBR加速 "
	green " 12. Linux换源脚本"
    green " 13. ipv4/6优先级调整 " 
    green " 14. 虚拟内存SWAP一键安装 "
    green " 15. 系统网络配置优化 "
    green " 16. 宝塔中文官方一键安装 "
	green " 17. 解除宝塔面板的强制绑定手机"
	

    blue  " =======科学上网工具====================================== "
    green " 21. v2-ui一键安装 "
    green " 22. xray一键安装八合一脚本 "
    green " 23. wulabing一键xray脚本 "
    green " 24. MTP&TLS 一键脚本 "
    green " 25. iptables一键中转 "
	green " 26. gost一键中转 "
	
    blue  " ========================================================== "
    yellow " 0. 退出脚本"
    echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in
         1 )  vpstest
	;;
         2 )  getip
	;;
         3 )  MediaUnlock_Test
	;;
         4 )  Netflix_Test
	;;
         5 )  Install_wget/curl
	;;
	     6 )  Oracle_Firewall
	;;
	     7 )  Oracle_root_passwd
	;;
	    11 )  Linux-NetSpeed 
	;;
	    12 )  cssh
	;;
	    13 )  ipvsh
	;;
	    14 )  swapsh
	;;
	    15 )  system-best
	;;
	    16 )  bt
	;;
	    17 )  btsj
	;;
	    18 )  
	;;
	    21 )  v2-ui
	;;
	    22 )  xray
	;;
	    23 )  wulabing
	;;
	    24 )  mtp
	;;
	    25 )  iptsh
	;;
	    26 )  gost
	;;
        0 )   exit 1
        ;;
        *) red "数字输入错误，3秒后请重新输入正确的数字 !"
		sleep 3s
		clear
		start_menu
        ;;
    esac
}


start_menu "first"