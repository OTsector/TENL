#!/bin/bash
### Welcome text
clear
red=`tput setaf 1`
grey=`tput setaf 8`
o=`tput setaf 65`
otext=`tput setaf 66`
t=`tput setaf 62`
ttext=`tput setaf 61`
reset=`tput sgr0`
bold=$(tput bold)
normal=$(tput sgr0)
banner=" \t\t ${bold}${t}_${reset}\n\t${bold}${o}0${reset}${normal}${bold}${t}7${reset}${normal}\t${o}[${reset}${t}|${reset}${o}]${reset}${normal} ${bold}${o}0${reset}${normal}${otext}ffensive${reset} ${bold}${t}7${reset}${normal}${ttext}ester${reset}\n\n\t# ${red}TENL${reset}${grey} - Tor Exit Node Lister v1.1.9${reset}\n"
echo -e ${banner}
### Welcome text
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 
	exit 1
fi
### Check addons
if ! [ -f /usr/bin/tor ] && ! [ -f /usr/bin/torload ] && ! [ -f /usr/bin/proxychains ] && ! [ -f /usr/bin/pc ] && ! [ -f /usr/bin/myip ]; then
	apt-get install git -y && git clone https://github.com/OTsector/torload.git && cd torload && sudo chmod +x configure.sh && sudo ./configure.sh || sudo rm -rf ../torload && cd ..
	exit 1
fi
### Check addons
if [[ $1 ]]; then
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
service tor start
service tor reload
while [[ true ]]; do
	service tor reload
	sleep 3s
	if [[ $1 ]]; then
		clear
		echo -e ${banner}
		{
		current=$(pc myip)
		list=$(echo $(grep -w $1 -e $current))
		filter1=$(echo $current|grep " \|-\|[a-z]")
		filter2="${current} ${current}"
		filter3="${current} ${current} ${current}"
		filter4="${current} ${current} ${current} ${current}"
		} &> /dev/null
		echo "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
		echo -e "\n\nCurrent:\t$current\nlist:\t\t$list\n\n"
		echo -e "------------------------------\n"
		if ! [[ ${filter1} == "" ]]; then
			echo wrong input. Skip mystic
		elif [[ $list == "${filter2}" ]] || [[ $list == "${filter3}" ]] || [[ $list == "${filter4}" ]]; then
			{
			sed -i '/'$current'/d' $1
			echo $current >> $1
			} &> /dev/null
			echo Fixed mystic
		elif [[ $current == "" ]] ; then
			echo Skip mystic
		elif ! [[ $list == "" ]] ; then
			echo ${red}Found - skip${reset}
		else
			echo ${green}Not found - save${reset}
			echo $current >> $1
		fi
		echo -e "\n//////////////////////////////\n"
	fi
done
else
	echo -e "select file location for create list. For example:\n\n	tenl.sh [file]\n"
fi
exit 0
