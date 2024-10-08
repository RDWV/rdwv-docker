#!/usr/bin/env bash
set -e
sudo apt install -y git
branch=${1:-master}
rm -rf compose/rdwv && git clone --depth=1 https://github.com/rdwv/rdwv -b $branch compose/rdwv
cd compose/rdwv
rm -rf .git
cat >conf/.env <<EOF
DB_HOST=database
REDIS_HOST=redis://redis
BTC_HOST=bitcoin
LTC_HOST=litecoin
BSTY_HOST=globalboost
BCH_HOST=bitcoincash
XRG_HOST=ergon
ETH_HOST=ethereum
BNB_HOST=binancecoin
SBCH_HOST=smartbch
MATIC_HOST=polygon
TRX_HOST=tron
GRS_HOST=groestlcoin
XMR_HOST=monero
EOF
cd ../..
