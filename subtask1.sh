#!/bin/bash
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++TASK 1+++++++++++++++++++++++++++++++++++++++++++++++++++"
echo '=================config'

sudo cat << EOF > /etc/sysconfig/watchlog
KEYWORD="ALERT"
LOGFILE=/var/log/mytest.log
EOF

echo '=================script'

sudo cat << EOF > /opt/watchlog.sh
#!/bin/bash
KEYWORD=\$1
LOGFILE=\$2
DATE=\`date\`

if grep \$KEYWORD \$LOGFILE &> /dev/null
then
logger "\$DATE: Alarm detected"
else
exit 0
fi

EOF

chmod +x /opt/watchlog.sh

echo '=================Unit'
sudo cat << EOF > /etc/systemd/system/watchlog.service
[Unit]
Description=Alarm watchlog service
[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh \$KEYWORD \$LOGFILE
EOF

echo '=================Set timer'
sudo cat << EOF > /etc/systemd/system/watchlog.timer
[Unit]
Description=Run watchlog script every 30 second
[Timer]
OnUnitActiveSec=30
Unit=watchlog.service
[Install]
WantedBy=multi-user.target

EOF
sudo systemctl daemon-reload
sudo systemctl start watchlog