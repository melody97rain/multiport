#wget https://github.com/${GitUser}/
GitUser="melody97rain"
#IZIN SCRIPT
MYIP=$(curl -sS ipv4.icanhazip.com)
MYIP=$(curl -s ipinfo.io/ip )
MYIP=$(curl -sS ipv4.icanhazip.com)
MYIP=$(curl -sS ifconfig.me )
echo -e "\e[32mloading...\e[0m"

clear
# LINE COLOUR
line=$(cat /etc/line)
# TEXT COLOUR BELOW
below=$(cat /etc/below)
# BACKGROUND TEXT COLOUR
back_text=$(cat /etc/back)
# NUMBER COLOUR
number=$(cat /etc/number)
# TEXT ON BOX COLOUR
box=$(cat /etc/box)
clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ifconfig.me/ip);
clear
echo -e ""
echo -e "   \e[$line════════════════════════════════════════\e[m"
echo -e "   \e[$back_text             \e[30m═[\e[$box SYSTEM MENU\e[30m ]═          \e[m"
echo -e "   \e[$line════════════════════════════════════════\e[m"
echo -e "   \e[$number (•1)\e[m \e[$below Add New Subdomain\e[m"
echo -e "   \e[$number (•2)\e[m \e[$below Renew Cert Xray Core\e[m"
echo -e "   \e[$number (•3)\e[m \e[$below DNS Changer\e[m"
echo -e "   \e[$number (•4)\e[m \e[$below Netflix Checker\e[m"
echo -e "   \e[$number (•5)\e[m \e[$below Panel Domain\e[m"
echo -e "   \e[$number (•6)\e[m \e[$below Backup Vps\e[m"
echo -e "   \e[$number (•7)\e[m \e[$below Restore Vps\e[m"
echo -e "   \e[$number (•8)\e[m \e[$below Install Webmin\e[m"
echo -e "   \e[$number (•9)\e[m \e[$below Setup Speed VPS\e[m"
echo -e "   \e[$number (10)\e[m \e[$below Restart VPN\e[m"
echo -e "   \e[$number (11)\e[m \e[$below Speedtest VPS\e[m"
echo -e "   \e[$number (12)\e[m \e[$below Xray Version\e[m"
echo -e "   \e[$number (13)\e[m \e[$below Install BBR\e[m"
echo -e "   \e[$number (14)\e[m \e[$below Install Ads Block\e[m"
echo -e "   \e[$number (15)\e[m \e[$below Ads Block Panel\e[m"
echo -e "   \e[$number (16)\e[m \e[$below ON/OF Auto Reboot\e[m"
echo -e "   \e[$number (17)\e[m \e[$below Change Password VPS\e[m"
echo -e "   \e[$number (18)\e[m \e[$below Check CPU & RAM\e[m"
echo -e "   \e[$number (19)\e[m \e[$below Change Banner SSH\e[m"
echo -e "   \e[$number (20)\e[m \e[$below SwapRAM Menu \e[m"
echo -e ""
echo -e "   \e[$number (66)\e[m \e[$below Install Noobzvpn\e[m"
echo -e "   \e[$number (77)\e[m \e[$below Uninstall Noobzvpn\e[m"
echo -e "   \e[$number (88)\e[m \e[$below Install UDP Custom\e[m"
echo -e "   \e[$number (99)\e[m \e[$below Xray-core Changer\e[m"
echo -e "   \e[$line════════════════════════════════════════\e[m"
echo -e "   \e[$back_text \e[$box x)   MENU                             \e[m"
echo -e "   \e[$line════════════════════════════════════════\e[m"
echo -e "\e[$line"
read -p "    Please Input Number  [1-99 or x] :  "  sys
echo -e ""
case $sys in
1)
lsof -t -i tcp:80 -s tcp:listen | xargs kill;add-host
;;
2)
certv2ray
;;
3)
dns
;;
4)
netf
;;
5)
panel-domain
;;
6)
backup
;;
7)
restore
;;
8)
wbmn
;;
9)
limit-speed
;;
10)
restart
;;
11)
speedtest
;;
12)
xray version
;;
13)
bbr
;;
14)
ins-helium
;;
15)
helium
;;
16)
autoreboot
;;
17)
passwd
;;
18)
htop
;;
19)
message-ssh
;;
20)
wget -q -O /usr/bin/swapram "https://raw.githubusercontent.com/melody97rain/swapram/main/swapram.sh" && chmod +x /usr/bin/swapram && swapram
;;
66)
rm -rf noobzvpns;git clone https://github.com/melody97rain/noobzvpns.git && cd noobzvpns && chmod +x install.sh && ./install.sh
;;
77)
cd noobzvpns && chmod +x uninstall.sh && ./uninstall.sh
;;
88)
wget https://raw.githubusercontent.com/melody97rain/addon/main/udp-custom/udp.sh && bash udp.sh
;;
99)
wget -q -O /usr/bin/xraychanger "https://raw.githubusercontent.com/NiLphreakz/XrayCore-Custompath/main/xraychanger.sh" && chmod +x /usr/bin/xraychanger && xraychanger
;;
x)
menu
;;
*)
echo "Please enter an correct number"
sleep 1
system
;;
esac
