#!/bin/sh
set -eu

: "${FTP_USER:?FTP_USER is required}"
: "${FTP_PASS:?FTP_PASS is required}"
: "${FTP_ROOT:=/var/www/html}"
: "${FTP_PASV_MIN:=21100}"
: "${FTP_PASV_MAX:=21110}"
: "${FTP_PASV_ADDRESS:=}"

if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" "$FTP_USER"
fi

echo "$FTP_USER:$FTP_PASS" | chpasswd

usermod -d "$FTP_ROOT" "$FTP_USER"
chown -R "$FTP_USER:$FTP_USER" "$FTP_ROOT" || true

sed -i "s/^pasv_min_port=.*/pasv_min_port=$FTP_PASV_MIN/" /etc/vsftpd.conf
sed -i "s/^pasv_max_port=.*/pasv_max_port=$FTP_PASV_MAX/" /etc/vsftpd.conf

if [ -n "$FTP_PASV_ADDRESS" ]; then
    if grep -q "^pasv_address=" /etc/vsftpd.conf; then
        sed -i "s/^pasv_address=.*/pasv_address=$FTP_PASV_ADDRESS/" /etc/vsftpd.conf
    else
        echo "pasv_address=$FTP_PASV_ADDRESS" >> /etc/vsftpd.conf
    fi
fi

exec /usr/sbin/vsftpd /etc/vsftpd.conf