#!/bin/bash
# Pastikan kebergantungan asas
for cmd in curl getent userdel; do
    if ! command -v $cmd >/dev/null 2>&1; then
        echo -e "\e[31mError: $cmd tiada. Sila pasang dulu!\e[0m"
        exit 1
    fi
done

GitUser="melody97rain"
# Dapatkan IP pelayan
MYIP=$(curl -s ipv4.icanhazip.com)
[ -z "$MYIP" ] && MYIP=$(curl -s ipinfo.io/ip)
[ -z "$MYIP" ] && MYIP=$(curl -s ifconfig.me)
if [ -z "$MYIP" ]; then
    echo -e "\e[31mGagal dapatkan IP pelayan!\e[0m"
    exit 1
fi

echo -e "\e[32mMemuatkan...\e[0m"
clear

# Fungsi semak validasi
VALIDITY () {
    today=$(date -d "0 days" +"%Y-%m-%d")
    Exp1=$(curl -s https://raw.githubusercontent.com/${GitUser}/allow/main/ipvps.conf | grep "$MYIP" | awk '{print $4}')
    if [[ -z "$Exp1" ]]; then
        echo -e "\e[31mIP tidak dijumpai dalam senarai!\e[0m"
        exit 1
    fi
    if [[ "$today" < "$Exp1" ]]; then
        echo -e "\e[32mSCRIPT AKTIF..\e[0m"
    else
        echo -e "\e[31mSCRIPT TELAH TAMAT TEMPOH!\e[0m"
        echo -e "\e[31mSila renew ipvps dulu\e[0m"
        exit 1
    fi
}

# Validasi kebenaran IP
IZIN=$(curl -s https://raw.githubusercontent.com/${GitUser}/allow/main/ipvps.conf | awk '{print $5}' | grep -w "$MYIP")
if [[ "$MYIP" == "$IZIN" ]]; then
    echo -e "\e[32mKebenaran diterima...\e[0m"
    VALIDITY
else
    echo -e "\e[31mKebenaran ditolak!\e[0m"
    echo -e "\e[31mSila beli script dulu\e[0m"
    exit 1
fi

echo -e "\e[32mMemuatkan...\e[0m"
clear

# Padam pengguna SSH
read -rp "Username SSH to Delete: " Pengguna
if getent passwd "$Pengguna" > /dev/null 2>&1; then
    userdel "$Pengguna"
    echo -e "User $Pengguna was removed."
else
    echo -e "Failure: User $Pengguna Not Exist."
fi
