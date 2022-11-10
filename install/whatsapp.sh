#!/bin/bash
clear
fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} -y > /dev/null 2>&1
${comando[1]} -y > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "  \033[1;33mAGUARDE \033[1;37m- \033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "  \033[1;33mAGUARDE \033[1;37m- \033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}
echo ""
clear
#
clear
whatsappatual=$(cut -d"'" -f2 /var/www/html/whatsapp)
echo -e "\E[44;1;37m    NÚMERO DO WHATSAPP     \E[0m"
echo ""
echo -e "\E[44;1;37m    Aqui você troca o número do whatsapp     \E[0m"
echo ""
echo -e "                              \033[1;31mBy @sonycssh\033[1;36m"
echo ""
echo ""
echo -e "\033[1;36m NOME ATUAL:\033[1;37m $whatsappatual\033[0m"
echo ""
echo -ne "\033[1;32m INFORME O NUMERO DO WHATSAPP (Ex: 11998547548)\033[1;37m: "; read -r whatsapp
echo ""
echo -e "   \033[1;32mOK\033[1;37m"
echo ""
clear
#
cd || exit
sed -i "s;$whatsappatual;$whatsapp;g" /var/www/html/whatsapp > /dev/null 2>&1
sed -i "s;$whatsappatual;$whatsapp;g" /var/www/html/index.php > /dev/null 2>&1
sed -i "s;$whatsappatual;$whatsapp;g" /var/www/html/login.php > /dev/null 2>&1
echo ""
service apache2 restart > /dev/null 2>&1
cat /dev/null > ~/.bash_history && history -c
rm /root/*.sh* > /dev/null 2>&1
clear
pweb
