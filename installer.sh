#--------------------------------------------------
# Softether auto install script
# Centos 7
# Created Feb. 10, 2019
# Latest Softether Server Version for May 2018 v4.28-9669-beta-2018.09.11
# Coded by Alaa Elrifaie
# Open Source Project From https://www.softether.org/
# From university of Tsukuba, Japan
# --------------------------------------------------
# Login with root permission or execute #sudo su
# Script start
# --------------------------------------------------

# Change Time Zone:
timedatectl set-timezone Asia/Riyadh

# Set working directory to root
cd /root

# Update the system
# First, please make sure all components are up to date.
yum update -y
sudo yum install epel-release -y

# Installation of other required tools
yum install wget nano net-tools -y

# Tools for building executable files are required:
yum groupinstall "Development Tools" -y

# Get latest SoftEther VPN Server Build for Linux from:
# http://www.softether-download.com/en.aspx
wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.28-9669-beta/softether-vpnserver-v4.28-9669-beta-2018.09.11-linux-x64-64bit.tar.gz
tar zxvf soft*

# Install
cd vpnserver/

#clear
echo  -e "\033[31;7mNOTE: ANSWER 1 AND ENTER THREE TIMES FOR THE COMPILATION TO PROCEED\033[0m"
# -- Installing, MANUAL INPUT --
make
cd ..
mv vpnserver /usr/local
rm -rf softethe*tat.gz
cd /usr/local/vpnserver/
chmod 600 *
chmod 700 vpnserver
chmod 700 vpncmd

# Installing the service
wget https://raw.githubusercontent.com/AlaaElrifaie/SoftEther-behind-pfSense/master/CentOS%207/vpn-server.sh
mv vpn-server.sh /etc/init.d/vpnserver

# Grant the permission of the file created.
chmod 755 /etc/init.d/vpnserver

# Set vpnserver to auto start. There are two hyphens before “add”.
chkconfig --add vpnserver

# Start the vpnserver.
service vpnserver start

# Firewall NOW
cd /root

echo "Now setting firewall rules..."

firewall-cmd --zone=public --add-service=openvpn --permanent
firewall-cmd --zone=public --add-service=ipsec --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --zone=public --add-port=992/tcp --permanent
# 1194 UDP might not be opened
# If you get TLS error, this may be the cause
firewall-cmd --zone=public --add-port=1194/udp --permanent
# NAT-T
# Ref: https://blog.cles.jp/item/7295
firewall-cmd --zone=public --add-port=500/udp --permanent # PORTFORWARD
firewall-cmd --zone=public --add-port=1701/udp --permanent # PORTFORWARD
firewall-cmd --zone=public --add-port=4500/udp --permanent # PORTFORWARD
# SoftEther
firewall-cmd --zone=public --add-port=5555/tcp --permanent # PORTFORWARD
# For UDP Acceleration
firewall-cmd --zone=public --add-port=40000-44999/udp --permanent # PORTFORWARD
firewall-cmd --reload

echo ---------------------------------------------
echo  -e "\033[32;5mVPN SERVER INSTALLED SUCCESSFULLY!\033[0m"
echo "SoftEther auto installer by Alaa Elrifaie"
echo ---------------------------------------------
