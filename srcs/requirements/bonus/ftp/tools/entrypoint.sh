#!/bin/sh
set -eu

if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" "$FTP_USER"
fi

echo "$FTP_USER:$FTP_PASS" | chpasswd

usermod -d "$FTP_ROOT" "$FTP_USER"
chown -R "$FTP_USER:$FTP_USER" "$FTP_ROOT" || true

sed -i "s/^pasv_min_port=.*/pasv_min_port=$FTP_PASV_MIN/" /etc/vsftpd.conf
sed -i "s/^pasv_max_port=.*/pasv_max_port=$FTP_PASV_MAX/" /etc/vsftpd.conf

exec /usr/sbin/vsftpd /etc/vsftpd.conf