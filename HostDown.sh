#!/bin/bash

##COLORES##

GR='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;37m'
NC='\033[0m'
YW='\033[1;33m'
bold=$(tput bold)
normal=$(tput sgr0)

#Ctrl-C#

trap ctrl_c INT


function ctrl_c() {
	echo -e "${bold} ${RED}[!] SALIENDO..."
        exit 1
}

function logo(){


	echo -e "${BLUE}██╗  ██╗ ██████╗ ███████╗████████╗    ██████╗  ██████╗ ██╗    ██╗███╗   ██╗
██║  ██║██╔═══██╗██╔════╝╚══██╔══╝    ██╔══██╗██╔═══██╗██║    ██║████╗  ██║
███████║██║   ██║███████╗   ██║       ██║  ██║██║   ██║██║ █╗ ██║██╔██╗ ██║
██╔══██║██║   ██║╚════██║   ██║       ██║  ██║██║   ██║██║███╗██║██║╚██╗██║
██║  ██║╚██████╔╝███████║   ██║       ██████╔╝╚██████╔╝╚███╔███╔╝██║ ╚████║
╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝       ╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝
${RED}                                                                           
                          ██████╗ ██╗  ██╗   ██╗                           
                          ██╔══██╗██║  ╚██╗ ██╔╝                           
                    █████╗██████╔╝██║   ╚████╔╝█████╗                      
                    ╚════╝██╔══██╗██║    ╚██╔╝ ╚════╝                      
                          ██████╔╝███████╗██║                              
                          ╚═════╝ ╚══════╝╚═╝                          ${NC}    
                                                                           "


}




base=$1
mascara=$2



if [ $# -ne 2 ];then

	echo "[!] Uso: $0 Direccion-Base Mascara"
	echo "[!] Ejemplo: $0 192.168.1.0 24"

else
	echo -e '\n'
	logo
	nmap -sP $1/$2 > .nmapscan &

	sleep 2
	echo -e "${bold} ${RED}[!] Esto puede tardar un poco..."
	sleep 4
	echo -e "${bold} ${GR}[$] Ya esta acabando :)"
	echo -e '\n'
	wait

	cat .nmapscan | grep -E "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" | cut -d ' ' -f5 > .hostdown
	rm -r .nmapscan


	for i in $(cat .hostdown);do

		base=$(echo $i | grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | cut -d '.' -f1,2,3)
		variable=$(echo $i| grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | cut -d '.' -f4)

		ip="$base.$(($variable+1))"

		if timeout 1 ping -c 1 $ip >/dev/null;then

			:

		else

			echo  -e "${NC}La direccion ${BLUE}${bold}$ip ${NC}${normal}esta ${YW}${bold}Libre"

		fi

	done

	echo -e "${GR}[!] Escaner finalizado"


fi
