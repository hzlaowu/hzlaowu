#!/bin/bash

blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

if [[ -f /etc/redhat-release ]]; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
fi

$systemPackage -y install wget curl

vps_superspeed(){
	bash <(curl -Lso- https://git.io/superspeed)
}

vps_zbench(){
	wget -N --no-check-certificate https://raw.githubusercontent.com/FunctionClub/ZBench/master/ZBench-CN.sh && bash ZBench-CN.sh
}

vps_testrace(){
	wget -N --no-check-certificate https://raw.githubusercontent.com/nanqinlang-script/testrace/master/testrace.sh && bash testrace.sh
}
vps_LemonBenchIntl(){
    curl -fsL https://ilemonra.in/LemonBenchIntl | bash -s fast
}
vps_Cn2GIA(){
    wget -N --no-check-certificate https://raw.githubusercontent.com/wangn9900/testvps/master/return.sh && bash return.sh
}

#Memorytest 内存压力测试
function memorytest(){
    yum install wget -y
    yum groupinstall "Development Tools" -y
    wget https://raw.githubusercontent.com/FunctionClub/Memtester/master/memtester.cpp
    blue "下载完成"
    gcc -l stdc++ memtester.cpp
    ./a.out
}

#hciptest
function hciptest(){
    read -p "输入你的回程目的IP地址:" hcip
	apt install unzip
 	wget https://cdn.ipip.net/17mon/besttrace4linux.zip
	unzip besttrace4linux.zip
    chmod +x besttracearm
    ./besttracearm -q1 -g cn $hcip 
	sleep 5s
    rm -r  *besttrace* 	
}



start_menu(){
    clear
	green "=========================================================="
     blue " 本脚本支持：CentOS7+ / Debian9+ / Ubuntu16.04+"
	 blue " 此脚本源于网络，只是汇聚脚本功能，仅做测试使用而已！"
	green "=========================================================="
   yellow " 简介：VPS综合性能测试脚本 （包含性能、速度、回程路由）"
    green "=========================================================="
      red " 脚本测速会大量消耗 VPS 流量，请悉知！"
    green "=========================================================="
     blue " 1. VPS 三网纯测速    （各取部分节点 - 中文显示）"
     blue " 2. VPS 综合性能测试  （包含测速 - 英文显示）"
	 blue " 3. VPS 回程路由      （四网测试 - 英文显示）"
	 blue " 4. VPS 快速全方位测速（包含性能、回程、速度 - 英文显示）"
	 blue " 5. VPS 回程线路测试  （假CN2线路，脚本无法测试）"
	 blue " 6. VPS 内存压力测试"
	 blue " 7. VPS 回程路由      （ipip脚本）"
   yellow " 0. 退出脚本"
    echo
    read -p "请输入数字:" num
    case "$num" in
    	1)
		vps_superspeed
		;;
		2)
		vps_zbench
		;;
		3)
		vps_testrace
		;;
		4)
		vps_LemonBenchIntl
		;;
		5)
		vps_Cn2GIA
		;;
		6)
		memorytest
		;;
		7)
		hciptest
		;;
		0)
		exit 0
		;;
		*)
	clear
	echo "请输入正确数字"
	sleep 2s
	start_menu
	;;
    esac
}

start_menu
