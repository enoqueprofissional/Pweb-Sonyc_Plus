#!/bin/bash
function msg {
  BRAN='\033[1;37m' && RED='\e[31m' && GREEN='\e[32m' && YELLOW='\e[33m'
  BLUE='\e[34m' && MAGENTA='\e[35m' && MAG='\033[1;36m' && BLACK='\e[1m' && SEMCOR='\e[0m'
  case $1 in
  -ne) cor="${RED}${BLACK}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -ama) cor="${YELLOW}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -verm) cor="${YELLOW}${BLACK}[!] ${RED}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -azu) cor="${MAG}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -verd) cor="${GREEN}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -bra) cor="${RED}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -nazu) cor="${COLOR[6]}${BLACK}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -gri) cor="\e[5m\033[1;100m" && echo -ne "${cor}${2}${SEMCOR}" ;;
  "-bar2" | "-bar") cor="${RED}————————————————————————————————————————————————————" && echo -e "${SEMCOR}${cor}${SEMCOR}" ;;
  esac
}
function fun_bar {
  comando="$1"
  _=$(
    $comando >/dev/null 2>&1
  ) &
  >/dev/null
  pid=$!
  while [[ -d /proc/$pid ]]; do
    echo -ne " \033[1;33m["
    for ((i = 0; i < 20; i++)); do
      echo -ne "\033[1;31m##"
      sleep 0.5
    done
    echo -ne "\033[1;33m]"
    sleep 1s
    echo
    tput cuu1
    tput dl1
  done
  echo -e " \033[1;33m[\033[1;31m########################################\033[1;33m] - \033[1;32m100%\033[0m"
  sleep 1s
}
function print_center {
  if [[ -z $2 ]]; then
    text="$1"
  else
    col="$1"
    text="$2"
  fi

  while read line; do
    unset space
    x=$(((54 - ${#line}) / 2))
    for ((i = 0; i < $x; i++)); do
      space+=' '
    done
    space+="$line"
    if [[ -z $2 ]]; then
      msg -azu "$space"
    else
      msg "$col" "$space"
    fi
  done <<<$(echo -e "$text")
}

function title {
  clear
  msg -bar
  if [[ -z $2 ]]; then
    print_center -azu "$1"
  else
    print_center "$1" "$2"
  fi
  msg -bar
}

function stop_install {
  [[ ! -e /bin/pweb ]]  && {
    title "INSTALAÇÃO CANCELADA"
    clear
    cat /dev/null > ~/.bash_history && history -c
    rm /bin/ubuinst* > /dev/null 2>&1
    exit;
 } || {
    title "INSTALAÇÃO CANCELADA"
    clear
    cat /dev/null > ~/.bash_history && history -c
    rm /bin/ubuinst* > /dev/null 2>&1
    exit;
}
}

function os_system {
  system=$(cat -n /etc/issue | grep 1 | cut -d ' ' -f6,7,8 | sed 's/1//' | sed 's/      //')
  distro=$(echo "$system" | awk '{print $1}')

  case $distro in
  Debian) vercion=$(echo $system | awk '{print $3}' | cut -d '.' -f1) ;;
  Ubuntu) vercion=$(echo $system | awk '{print $2}' | cut -d '.' -f1,2) ;;
  esac
}
function dependencias {
  soft="python bc screen at nano unzip lsof netstat net-tools dos2unix nload jq python3 python-pip"
   for i in $soft; do
    leng="${#i}"
    puntos=$((21 - $leng))
    pts="."
    for ((a = 0; a < $puntos; a++)); do
      pts+="."
    done
    msg -nazu "    INSTALANDO $i$(msg -ama "$pts")"
    if apt install $i -y &>/dev/null; then
      msg -verd " INSTALADO"
    else
      msg -verm2 " ERRO"
      sleep 2
      tput cuu1 && tput dl1
      print_center -ama "APLICANDO FIX A $i"
      dpkg --configure -a &>/dev/null
      sleep 2
      tput cuu1 && tput dl1

      msg -nazu "    INSTALANDO $i$(msg -ama "$pts")"
      if apt install $i -y &>/dev/null; then
        msg -verd " INSTALADO"
      else
        msg -verm2 " ERRO"
      fi
    fi
  done
}
function install_start {
if [[ -e "/var/www/html/pages/system/pass.php" ]]; then
clear
msg -bar
echo -e "\033[1;31mPAINEL JÁ INSTALDO EM SUA VPS, RECOMENDO\033[0m"
echo -e "\033[1;31mUMA FORMATAÇÃO PARA UMA NOVA INSTALÇÃO!\033[0m"
msg -bar
sleep 5
systemctl restart apache2 > /dev/null 2>&1
cat /dev/null > ~/.bash_history && history -c
rm /bin/ubuinst* > /dev/null 2>&1
exit;
else
  echo -e 'Modificado por: @sonycssh' >/usr/lib/telegram
  msg -bar
  echo -e "\e[1;97m           \e[5m\033[1;100m   ATUALIZAÇÃO DO SISTEMA   \033[1;37m"
  msg -bar
  print_center -ama "O sistema será atualizado.\n Pode demorar um pouco e pedir algumas confirmações.\n"
  msg -bar3
  msg -ne "\n Você deseja continuar? [S/n]: "
  read opcion
  [[ "$opcion" != @(s|S) ]] && stop_install
  clear && clear
  os_system
  msg -bar
  echo -e "\e[1;97m           \e[5m\033[1;100m   ATUALIZAÇÃO DO SISTEMA   \033[1;37m"
  msg -bar
  apt install software-properties-common
  apt update -y
  apt install figlet -y
  apt-get install figlet boxes -y
  apt-get install lolcat -y
  apt install curl -y
  add-apt-repository ppa:ondrej/php -y
  apt update -y
  apt upgrade -y
  clear
  msg -bar
  echo -e "\e[1;97m   \e[5m\033[1;100mATUALIZAÇÃO DO SISTEMA CONCLUÍDA COM SUCESSO!\033[1;37m"
  msg -bar
  sleep 3
  clear
fi
}

function install_continue {
  os_system
  msg -bar
  echo -e "      \e[5m\033[1;100m   CONCLUINDO PACOTES PARA O SCRIPT   \033[1;37m"
  msg -bar
  print_center -ama "$distro $vercion"
  print_center -verd "INSTALANDO DEPENDÊNCIAS"
  msg -bar3
  dependencias
  msg -bar3
  print_center -azu "Removendo pacotes obsoletos"
  apt autoremove -y &>/dev/null
  sleep 2
  tput cuu1 && tput dl1
  msg -bar
  print_center -ama "Se algumas das dependências falharem!!!\nQuando terminar, você pode tentar instalar\no mesmo manualmente usando o seguinte comando\napt install nome_do_pacote"
  msg -bar
  read -t 60 -n 1 -rsp $'\033[1;39m       << Pressione enter para continuar >>\n'
}
function install_continue2 {
cd /bin || exit
rm pweb > /dev/null 2>&1
wget https://github.com/lucianolima2905/Pweb-Sonyc_Plus/raw/main/install/pweb > /dev/null 2>&1
chmod 777 pweb > /dev/null 2>&1
clear
[[ ! -d /bin/ppweb ]] && mkdir /bin/ppweb
cd /bin/ppweb || exit
rm *.sh ver* > /dev/null 2>&1
wget https://github.com/lucianolima2905/Pweb-Sonyc_Plus/raw/main/install/verifatt.sh > /dev/null 2>&1
wget https://github.com/lucianolima2905/Pweb-Sonyc_Plus/raw/main/install/verpweb > /dev/null 2>&1
wget https://github.com/lucianolima2905/Pweb-Sonyc_Plus/raw/main/install/verweb > /dev/null 2>&1
wget https://github.com/lucianolima2905/Pweb-Sonyc_Plus/raw/main/install/whatsapp.sh > /dev/null 2>&1
verp=$(sed -n '1 p' /bin/ppweb/verpweb| sed -e 's/[^0-9]//ig') &>/dev/null
verw=$(sed -n '1 p' /bin/ppweb/verweb| sed -e 's/[^0-9]//ig') &>/dev/null
echo -e "$verp" >/bin/ppweb/attpweb
echo -e "$verw" >/bin/ppweb/attweb
chmod 777 *.sh > /dev/null 2>&1
[[ ! -e /etc/autostart ]] && {
	echo '#!/bin/bash
clear
#INICIO AUTOMATICO' >/etc/autostart
	chmod +x /etc/autostart
}
}
function inst_base {
    echo -e "\n\033[1;36mINSTALANDO O APACHE2 \033[1;33mAGUARDE...\033[0m"
apt install apache2 -y > /dev/null 2>&1
apt install dirmngr apt-transport-https -y > /dev/null 2>&1
apt install php8.1 libapache2-mod-php8.1 php8.1-xml php8.1-mcrypt php8.1-curl php8.1-mbstring php8.1-cli -y > /dev/null 2>&1
systemctl restart apache2 > /dev/null 2>&1
apt-get install mariadb-server -y > /dev/null 2>&1
cd || exit
echo -e "\n\033[1;36mINSTALANDO O MySQL \033[1;33mAGUARDE...\033[0m"
mysqladmin -u root password "$pwdroot" > /dev/null 2>&1
mysql -u root -p"$pwdroot" -e "UPDATE mysql.user SET Password=PASSWORD('$pwdroot') WHERE User='root'" > /dev/null 2>&1
mysql -u root -p"$pwdroot" -e "FLUSH PRIVILEGES" > /dev/null 2>&1
mysql -u root -p"$pwdroot" -e "DELETE FROM mysql.user WHERE User=''" > /dev/null 2>&1
mysql -u root -p"$pwdroot" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'" > /dev/null 2>&1
mysql -u root -p"$pwdroot" -e "FLUSH PRIVILEGES" > /dev/null 2>&1
mysql -u root -p"$pwdroot" -e "CREATE DATABASE sshplus;" > /dev/null 2>&1
mysql -u root -p"$pwdroot" -e "GRANT ALL PRIVILEGES ON sshplus.* To 'root'@'localhost' IDENTIFIED BY '$pwdroot';" > /dev/null 2>&1
mysql -u root -p"$pwdroot" -e "FLUSH PRIVILEGES" > /dev/null 2>&1
echo '[mysqld]
max_connections = 1000' >> /etc/mysql/my.cnf
apt install php8.1-mysql -y > /dev/null 2>&1
phpenmod mcrypt > /dev/null 2>&1
systemctl restart apache2 > /dev/null 2>&1
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin > /dev/null 2>&1
apt install php8.1-ssh2 -y > /dev/null 2>&1
php -m | grep ssh2 > /dev/null 2>&1
curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
mv composer.phar /usr/local/bin/composer > /dev/null 2>&1
chmod +x /usr/local/bin/composer > /dev/null 2>&1
cd /var/www/html || exit
wget https://github.com/lucianolima2905/Pweb-Sonyc_Plus/raw/main/install/gestorssh.zip > /dev/null 2>&1
apt-get install unzip > /dev/null 2>&1
unzip gestorssh.zip > /dev/null 2>&1
(echo yes; echo yes; echo yes; echo yes) | composer install > /dev/null 2>&1
(echo yes; echo yes; echo yes; echo yes) | composer require phpseclib/phpseclib:~2.0 > /dev/null 2>&1
ln -s /usr/share/phpmyadmin/ /var/www/html > /dev/null 2>&1
chmod 777 -R /var/www/html > /dev/null 2>&1
rm gestorssh.zip index.html > /dev/null 2>&1
systemctl restart mysql
clear
}
function phpmadm {
cd /usr/share || exit
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip > /dev/null 2>&1
unzip phpMyAdmin-5.2.0-all-languages.zip > /dev/null 2>&1
mv phpMyAdmin-5.2.0-all-languages phpmyadmin > /dev/null 2>&1
chmod -R 0777 phpmyadmin > /dev/null 2>&1
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin > /dev/null 2>&1
systemctl restart apache2 > /dev/null 2>&1 
rm phpMyAdmin-5.2.0-all-languages.zip > /dev/null 2>&1
cd /root || exit
}

function pconf { 
sed "s/1020/$pwdroot/" /var/www/html/pages/system/pass.php > /tmp/pass
mv /tmp/pass /var/www/html/pages/system/pass.php

}
function inst_db { 
sed -i "s;dominio;$IP;g" /var/www/html/bdgestorssh.sql > /dev/null 2>&1
sleep 1
if [[ -e "/var/www/html/bdgestorssh.sql" ]]; then
    mysql -h localhost -u root -p"$pwdroot" --default_character_set utf8 sshplus < /var/www/html/bdgestorssh.sql > /dev/null 2>&1
    rm /var/www/html/bdgestorssh.sql > /dev/null 2>&1
else
    clear
    echo -e "\033[1;31m ERRO CRÍTICO\033[0m"
    sleep 2
    systemctl restart apache2 > /dev/null 2>&1
cat /dev/null > ~/.bash_history && history -c
rm /bin/ubuinst* > /dev/null 2>&1
clear
exit;
fi
clear
}
function cron_set {
crontab -l > cronset > /dev/null 2>&1
echo "
@reboot /etc/autostart
* * * * * /etc/autostart
0 */12 * * * cd /var/www/html/pages/system/ && bash cron.backup.sh && cd /root
5 */3 * * * cd /var/www/html/pages/system/ && /usr/bin/php cron.backup.php && cd /root
* * * * * cd /var/www/html/pages/system/ && bash cron.userteste.sh && cd /root
2 */3 * * * cd /var/www/html/pages/system/ && bash cron.autobackup.sh && cd /root
* * * * * /usr/bin/php /var/www/html/pages/system/cron.online.ssh.php
@daily /usr/bin/php /var/www/html/pages/system/cron.rev.php
* * * * * /usr/bin/php /var/www/html/pages/system/cron.ssh.php
* * * * * /usr/bin/php /var/www/html/pages/system/cron.php
*/30 * * * * /usr/bin/php /var/www/html/pages/system/hist.online.php" > cronset
crontab cronset && rm cronset > /dev/null 2>&1
}
function fun_swap {
			swapoff -a
            rm -rf /bin/ram.img > /dev/null 2>&1
            fallocate -l 4G /bin/ram.img > /dev/null 2>&1
            chmod 600 /bin/ram.img > /dev/null 2>&1
            mkswap /bin/ram.img > /dev/null 2>&1
            swapon /bin/ram.img > /dev/null 2>&1
            echo 50  > /proc/sys/vm/swappiness
            echo '/bin/ram.img none swap sw 0 0' | tee -a /etc/fstab > /dev/null 2>&1
            sleep 2
}
function tst_bkp {
cd || exit
sed -i "s;49875103u;$pwdroot;g" /var/www/html/pages/system/config.php > /dev/null 2>&1
sed -i "s;localhost;$IP;g" /var/www/html/pages/system/config.php > /dev/null 2>&1
sed -i "s;1020;$pwdroot;g" /var/www/html/config/config.php > /dev/null 2>&1
}
clear
install_start
IP=$(wget -qO- ipv4.icanhazip.com)
echo "America/Sao_Paulo" > /etc/timezone > /dev/null 2>&1
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime > /dev/null 2>&1
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
clear
echo -e "\E[44;1;37m    INSTALANDO PAINEL    \E[0m"
echo ""
echo -e "WEB SONYC SSH" | figlet | boxes -d stone -p a0v0 | lolcat
echo -e "                              \033[1;31mModificado por @sonycssh\033[1;36m" | lolcat
echo ""
chave=$(curl -sSL "https://github.com/lucianolima2905/Pweb-Sonyc_Plus/raw/main/install/chave") &>/dev/null

read -p "DIGITE A CHAVE DE INSTALAÇÃO: " key
    
         if [[ "$key" = "$chave" ]]
         then
               echo -e "[*] VALIDANDO A CHAVE DE INSTALAÇÃO"
                sleep 2
                echo $key > /bin/chave_inst
                echo -e "[*] CHAVE ACEITA"
                sleep 2
            else
            echo "[-] ESSA CHAVE NÃO É VÁLIDA!"
            sleep 3
            clear
            cat /dev/null > ~/.bash_history && history -c
            rm /bin/ubuinst* > /dev/null 2>&1
            exit;
          fi
install_continue
install_continue2
[[ $(grep -c "prohibit-password" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/prohibit-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "without-password" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/without-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PermitRootLogin" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication" /etc/ssh/sshd_config) = '0' ]] && {
	echo 'PasswordAuthentication yes' > /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
echo ""
echo -e "WEB SONYC SSH" | figlet | boxes -d stone -p a0v0 | lolcat
echo -e "                              \033[1;31mModificado por @sonycssh\033[1;36m" | lolcat
echo ""
echo -e "\033[1;36mDEFINA UMA NOVA SENHA PARA\033[0m" | lolcat
echo -e "\033[1;36mO USUÁRIO ROOT DA VPS E\033[0m" | lolcat
echo -e "\033[1;36mPARA O USUÁRIO DO PHPMYADMIN!\033[0m" | lolcat
echo ""
read -p "DIGITE UMA NOVA SENHA ROOT: " pwdroot
echo "root:$pwdroot" | chpasswd
echo -e "\n\033[1;36mINICIANDO INSTALAÇÃO \033[1;33mAGUARDE..."
sleep 3
clear
inst_base
phpmadm
pconf
inst_db
cron_set
fun_swap
tst_bkp
clear
sed -i "s;upload_max_filesize = 2M;upload_max_filesize = 256M;g" /etc/php/8.1/apache2/php.ini > /dev/null 2>&1
sed -i "s;post_max_size = 8M;post_max_size = 256M;g" /etc/php/8.1/apache2/php.ini > /dev/null 2>&1
echo -e "PAINEL WEB SONYC SSH" | figlet | boxes -d stone -p a0v0 | lolcat
echo -e "                              \033[1;31mModificado por @sonycssh\033[1;36m" | lolcat
echo ""
echo -e "\033[1;32mPAINEL INSTALADO COM SUCESSO!" | lolcat
echo ""
echo -e "\033[1;36m SEU PAINEL:\033[1;37m http://$IP/admin\033[0m"
echo -e "\033[1;36m USUÁRIO:\033[1;37m admin\033[0m"
echo -e "\033[1;36m SENHA:\033[1;37m admin\033[0m"
echo ""
echo -e "\033[1;36m LOJA DE APPS:\033[1;37m http://$IP/apps\033[0m"
echo ""
echo -e "\033[1;36m PHPMYADMIN:\033[1;37m http://$IP/phpmyadmin\033[0m"
echo -e "\033[1;36m USUÁRIO:\033[1;37m root\033[0m"
echo -e "\033[1;36m SENHA:\033[1;37m $pwdroot\033[0m"
echo ""
echo -e "\033[1;31m \033[1;33mCOMANDO PRINCIPAL: \033[1;32mpweb\033[0m"
echo -e "\033[1;33m MAIS INFORMAÇÕES \033[1;31m(\033[1;36mTELEGRAM\033[1;31m): \033[1;37m@sonycssh\033[0m" | lolcat
echo ""
echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar...\033[1;32m! \033[0m"; read
systemctl restart apache2 > /dev/null 2>&1
systemctl restart mysql > /dev/null 2>&1
cat /dev/null > ~/.bash_history && history -c
rm /bin/ubuinst* > /dev/null 2>&1
clear
