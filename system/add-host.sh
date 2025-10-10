#!/bin/bash
# // CODE WARNA
export RED='\e[1;31m'
export GREEN='\e[0;32m'
export BLUE='\e[0;34m'
export NC='\e[0m'

#wget https://github.com/${GitUser}/
GitUser="melody97rain"

# // MY IPVPS
export MYIP=$(curl -sS ipv4.icanhazip.com)
MYIP=$(curl -s ipinfo.io/ip )
MYIP=$(curl -sS ipv4.icanhazip.com)
MYIP=$(curl -sS ifconfig.me )

# // VALID SCRIPT
clear
VALIDITY () {
    today=`date -d "0 days" +"%Y-%m-%d"`
    Exp1=$(curl -sS https://raw.githubusercontent.com/${GitUser}/allow/main/ipvps.conf | grep $MYIP | awk '{print $4}')
    if [[ $today < $Exp1 ]]; then
    echo -e "\e[32mYOUR SCRIPT ACTIVE..\e[0m"
    else
    echo -e "\e[31mYOUR SCRIPT HAS EXPIRED!\e[0m";
    echo -e "\e[31mPlease renew your ipvps first\e[0m"
    exit 0
fi
}
IZIN=$(curl -sS https://raw.githubusercontent.com/${GitUser}/allow/main/ipvps.conf | awk '{print $5}' | grep $MYIP)
if [ $MYIP = $IZIN ]; then
echo -e "\e[32mPermission Accepted...\e[0m"
VALIDITY
sleep 0.1
else
echo -e "\e[31mPermission Denied!\e[0m";
echo -e "\e[31mPlease buy script first\e[0m"
exit 0
fi

#!/usr/bin/env bash
# prompt domain/email -> install/repair acme.sh -> issue & install cert
# This version REMOVES ALL trojan-go references but KEEPS xray control.
# Run as root.
set -euo pipefail

# Colors
RED='\e[1;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
err()   { echo -e "${RED}[ERR]${NC} $*"; }

# Ensure dirs
mkdir -p /usr/local/etc/xray /var/lib/premium-script

default_email="$(cat /usr/local/etc/xray/email 2>/dev/null || echo "")"

# Prompt domain
echo -e "${BLUE}=====================================================${NC}"
echo -e "                    Add Domain"
echo -e "${BLUE}=====================================================${NC}"
echo ""
read -rp "Domain/Host: " host_raw
host="$(echo "${host_raw}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
if [[ -z "$host" ]]; then
  err "No domain provided. Exiting."
  exit 1
fi

# write IP= only once
if ! grep -qxF "IP=${host}" /var/lib/premium-script/ipvps.conf 2>/dev/null; then
  echo "IP=${host}" >> /var/lib/premium-script/ipvps.conf
  ok "Wrote IP=${host} to /var/lib/premium-script/ipvps.conf"
else
  info "Entry IP=${host} already exists in /var/lib/premium-script/ipvps.conf"
fi

# save domain
echo "$host" > /usr/local/etc/xray/domain
domain="$host"
ok "Wrote domain to /usr/local/etc/xray/domain -> $domain"

# email
echo ""
echo -e "   \e[1;32mPlease enter your email for ACME account.\e[0m"
echo -e "   \e[1;31m(Press ENTER to use existing default: '${default_email}')\e[0m"
read -rp "Email : " email_input
if [[ -z "${email_input// /}" ]]; then
  account_email="$default_email"
else
  account_email="$email_input"
fi
echo "$account_email" > /usr/local/etc/xray/email
info "Saved account email to /usr/local/etc/xray/email"

# ACME provider choice
echo ""
echo -e "   .-----------------------------------."
echo -e "   |   \e[1;32mPlease select ACME provider\e[0m   |"
echo -e "   '-----------------------------------'"
echo -e "     \e[1;32m1)\e[0m ZeroSSL"
echo -e "     \e[1;32m2)\e[0m Buypass"
echo -e "     \e[1;32m3)\e[0m Let's Encrypt (default)"
read -rp "Choose 1-3 (default 3): " acmee_choice
case "$acmee_choice" in
  1) acme_server="zerossl" ;;
  2) acme_server="https://api.buypass.com/acme/directory" ;;
  *) acme_server="letsencrypt" ;;
esac
info "Using ACME server: $acme_server"

# // STOP XRAY
systemctl stop xray.service
systemctl stop xray@none

# Check port 80 and stop xray if needed
info "Checking port 80 usage..."
if ss -ltnp 2>/dev/null | grep -q ':80'; then
  info "Port 80 in use — attempting to stop xray to free it."
  systemctl stop xray 2>/dev/null || true
  sleep 0.6
  if ss -ltnp 2>/dev/null | grep -q ':80'; then
    err "Port 80 still in use. Free port 80 and re-run script (or use DNS mode)."
    ss -ltnp | grep ':80' || true
    exit 1
  fi
fi

# Install/repair acme.sh
info "Installing/reinstalling acme.sh..."
if [[ -d /root/.acme.sh ]]; then
  info "Backing up existing /root/.acme.sh -> /root/.acme.sh.bak"
  rm -rf /root/.acme.sh.bak || true
  mv /root/.acme.sh /root/.acme.sh.bak || true
fi

# ensure git/curl
if ! command -v git >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update -y
    apt-get install -y git curl ca-certificates openssl || true
  else
    err "git not found and apt-get not available. Install git/curl then re-run."
    exit 1
  fi
fi

TMP_SRC="/root/acme.sh-src-$$"
rm -rf "$TMP_SRC" || true
git clone https://github.com/acmesh-official/acme.sh.git "$TMP_SRC"
cd "$TMP_SRC"
bash ./acme.sh --install --home /root/.acme.sh --nocron
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --version || true
ok "acme.sh installed"

# Register account
if [[ -n "$account_email" ]]; then
  info "Registering account with email: $account_email"
  /root/.acme.sh/acme.sh --server "$acme_server" --register-account --accountemail "$account_email" || true
else
  info "Registering account without email"
  /root/.acme.sh/acme.sh --server "$acme_server" --register-account || true
fi

# Issue certificate (standalone)
info "Issuing certificate for domain: $domain (standalone mode)."
if /root/.acme.sh/acme.sh --server "$acme_server" --issue -d "$domain" --standalone -k ec-256; then
  ok "Certificate issued for $domain"
else
  err "Certificate issuance FAILED. Showing acme.sh logs if any:"
  ls -la /root/.acme.sh/"$domain" 2>/dev/null || true
  tail -n 200 /root/.acme.sh/"$domain"/* 2>/dev/null || true
  # try to start xray back (since we stopped it earlier)
  systemctl start xray 2>/dev/null || true
  exit 1
fi

# Install cert to xray path; reloadcmd only restarts xray
info "Installing certificate into /usr/local/etc/xray (reloadcmd will restart xray only)"
mkdir -p /usr/local/etc/xray
if /root/.acme.sh/acme.sh --install-cert -d "$domain" \
    --fullchainpath /usr/local/etc/xray/xray.crt \
    --keypath /usr/local/etc/xray/xray.key \
    --ecc \
    --reloadcmd "systemctl restart xray"; then
  ok "Certificate installed to /usr/local/etc/xray/"
else
  err "install-cert failed. See acme.sh output above."
  systemctl start xray 2>/dev/null || true
  exit 1
fi

# secure perms
chown root:root /usr/local/etc/xray/xray.crt /usr/local/etc/xray/xray.key || true
chmod 644 /usr/local/etc/xray/xray.crt || true
chmod 600 /usr/local/etc/xray/xray.key || true

# restart xray (ensure it's running)
systemctl restart xray 2>/dev/null || true

ok "Done. Certificate for ${domain} is installed to /usr/local/etc/xray/xray.crt and xray.key"
ls -l /usr/local/etc/xray/xray.* || true

# // RESTART XRAY
systemctl restart xray.service
systemctl restart xray@none

clear
echo -e ""
echo -e "\033[0;34m══════════════════════════════════════════\033[0m"
echo -e "\E[44;1;39m        PERTUKARAN DOMAIN SELESAI         \E[0m"
echo -e "\033[0;34m══════════════════════════════════════════\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
