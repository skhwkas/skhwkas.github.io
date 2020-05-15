#!/bin/sh
while [ 1 ]; do
echo -n "\nAre you sure? (y/N) : "
read a
if [ x$a = "xy" ]
then
break
else
exit
fi
done

apt-get update;apt-get upgrade -y;apt-get install git -y;

# 업데이트 목록 갱신 및 업데이트 가능한 모든 패키지 업그레이드, git을 설치합니다.

apt-get install zram-config -y;

# zram 설치 

apt-get install cron -y;

# cron 설치 

# ---------GeoIP----------

apt-get install curl unzip perl;
apt-get install xtables-addons-common;
apt-get install libtext-csv-xs-perl libmoosex-types-netaddr-ip-perl;

git clone https://github.com/mschmitt/GeoLite2xtables.git;
mv GeoLite2xtables /usr/local/src;

mkdir /usr/share/xt_geoip;
./usr/local/src/GeoLite2xtables/00_download_geolite2;
./usr/local/src/GeoLite2xtables/10_download_countryinfo;
cat /tmp/GeoLite2-Country-Blocks-IPv{4,6}.csv |./20_convert_geolite2 /tmp/CountryInfo.txt &gt; /usr/share/xt_geoip/GeoIP-legacy.csv;
/usr/lib/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip /usr/share/xt_geoip/GeoIP-legacy.csv;

modprobe xt_geoip;
lsmod | grep ^xt_geoip;
iptables -m geoip –help;

while [ 1 ]; do
echo -n "\n\nIs GeoIP working? (y/N) : "
read a
if [ x$a = "xy" ]
then
break
else
exit
fi
done

# ------------------------

mkdir /etc/backup/;
cp /etc/sysctl.conf /etc/backup/;cp /etc/iptables/rules.v4 /etc/backup/;

# sysctl.conf (리눅스 커널 설정 파일), rules.v4 (iptables 설정 파일)을 /etc/backup 폴더에 백업합니다.
# 백업 폴더 위치 : /etc/backup/

git clone https://github.com/skhwkas/anti-ddos.git;
mv anti-ddos /etc/;

# 소스코드 다운로드

rm /etc/sysctl.conf;cp /etc/anti-ddos/sysctl.conf /etc/;

# /etc/sysctl.conf/ (리눅스 커널 설정 파일)을 덮어씌웁니다. 백업파일은 /etc/backup  폴더에있습니다.
# 네트워크 최적화, ip스푸핑 방어, tcpbbr(https://cloud.google.com/blog/products/gcp/tcp-bbr-congestion-control-comes-to-gcp-your-internet-just-got-faster), 디도스완화가 적용되어있습니다.

apt-get install iptables-persistent -y;

cp /usr/share/netfilter-persistent/plugins.d/15-ip4tables /etc/init.d/iptables;
/etc/init.d/iptables start;
/etc/init.d/iptables flush;
update-rc.d -f iptables defaults;

# 우분투 iptables 서비스 활성화
# insserv: warning: script ‘K01iptables’ missing LSB tags and overrides
# insserv: warning: script ‘iptables’ missing LSB tags and overrides
# 위와 같은 애러가 표시될 경우 게시글(https://idchowto.com/?p=31482)을 참조하여 문제를 해결해주세요.

cat /etc/anti-ddos/rules.v4 >> /etc/iptables/rules.v4;

# rules.v4 (iptables 설정 파일)에 내용을 추가합니다.
# 디도스공격 완화, IP 차단, ICMP 차단을 적용합니다.

while [ 1 ]; do
echo -n "\n\nReboot NOW? (y/N) : "
read a
if [ x$a = "xy" ]
then
break
else
exit
fi
done

reboot;

# 서버 재부팅
