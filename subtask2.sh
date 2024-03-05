#!/bin/bash
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++TASK 2+++++++++++++++++++++++++++++++++++++++++++++++++++"
sudo cd /etc/yum.repos.d/
sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sudo dnf upgrade -y libmodulemd 

echo '=================install epel-release and spawn-fcgi'

sudo yum install epel-release -y 
sudo yum install spawn-fcgi php php-cli mod_fcgid httpd -y


sudo cat << EOF > /etc/sysconfig/spawn-fcgi
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u apache -g apache -s \$SOCKET -S -M 0600 -C 32 -F 1 -P /var/run/spawn-fcgi.pid -- /usr/bin/php-cgi"

EOF


echo '=================unit service'

sudo cat << EOF > /etc/systemd/system/spawn-fcgi.service
[Unit]
Description=Spawn-fcgi
After=network.target
[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n \$OPTIONS
KillMode=process
[Install]
WantedBy=multi-user.target
EOF

echo '=================Reload service'
sudo systemctl daemon-reload
sudo systemctl start spawn-fcgi
sudo systemctl status spawn-fcgi