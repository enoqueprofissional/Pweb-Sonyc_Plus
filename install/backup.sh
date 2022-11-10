#!/bin/bash
if [ -f "/root/usuarios.db" ]; then
[[ -e "/etc/openvpn" ]] && {
	echo ""
	echo -e "Certificado Ovpn localizado..."
	rm -rf $HOME/backup.vps >/dev/null 2>&1
	sleep 1
	tar cvf /root/backup.vps /root/usuarios.db /etc/shadow /etc/passwd /etc/group /etc/gshadow /etc/SSHPlus/senha /etc/SSHPlus/bot-telegram /etc/v2ray/config.json /etc/v2ray/domain.txt /etc/v2ray/v2ray.crt /etc/v2ray/v2ray.key >/dev/null 2>&1
	echo ""
	echo "BACKUP CRIADO COM SUCESSO !"
	echo ""
	} || {
	rm -rf $HOME/backup.vps >/dev/null 2>&1
	sleep 1
	tar cvf /root/backup.vps /root/usuarios.db /etc/shadow /etc/passwd /etc/group /etc/gshadow /etc/SSHPlus/senha /etc/SSHPlus/bot-telegram >/dev/null 2>&1
	echo ""
	echo "BACKUP CRIADO COM SUCESSO !"
	echo ""
	} || {
	rm -rf $HOME/backup.vps >/dev/null 2>&1
	sleep 1
	tar cvf /root/backup.vps /root/usuarios.db /etc/shadow /etc/passwd /etc/group /etc/gshadow /etc/SSHPlus/senha /etc/SSHPlus/v2ray /etc/openvpn $HOME/BOT/permitidos $HOME/BOT/revenda >/dev/null 2>&1
	echo ""
	echo "BACKUP CRIADO COM SUCESSO !"
	echo ""
	} || {
	rm -rf $HOME/backup.vps >/dev/null 2>&1
	sleep 1
	tar cvf /root/backup.vps /etc/shadow /etc/passwd /etc/group /etc/gshadow /etc/SSHPlus/senha /etc/SSHPlus/v2ray $HOME/BOT/permitidos $HOME/BOT/revenda >/dev/null 2>&1
	echo ""
	echo "BACKUP CRIADO COM SUCESSO !"
	echo ""
	} || {
	rm -rf $HOME/backup.vps >/dev/null 2>&1
	sleep 1
	tar cvf /root/backup.vps /etc/shadow /etc/passwd /etc/group /etc/gshadow /etc/SSHPlus/senha >/dev/null 2>&1
	echo ""
	echo "BACKUP CRIADO COM SUCESSO !"
	echo ""
	}
	echo -e "Disponivel em\033[1;31m" ~/"backup.vps"
fi
