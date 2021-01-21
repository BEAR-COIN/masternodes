#/bin/bash
show_menu(){
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    number=`echo "\033[33m"` #yellow
    bgred=`echo "\033[41m"`
    fgred=`echo "\033[31m"`
    printf "\n${menu}*********************************************${normal}"
    printf "\n${menu}**** BEAR Coin Multi Masternodes Manager ****${normal}"
    printf "\n${menu}***************** ver 1.0.2 *****************${normal}"
    printf "\n${menu}*********** https://bearcoin.net ************${normal}"
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${number} 1)${menu} Get VPS info ${normal}\n"
    printf "${menu}**${number} 2)${menu} Get masternodes info ${normal}\n"
    printf "\n"

    printf "${menu}**${number} 3)${menu} Install masternode ${normal}\n"
    printf "${menu}**${number} 4)${menu} Delete masternode ${normal}\n"
    printf "\n"
    
    printf "${menu}**${number} 5)${menu} Start masternode ${normal}\n"
    printf "${menu}**${number} 6)${menu} Stop masternode ${normal}\n"
    printf "\n"

    printf "${menu}Additional options (be careful!) ${normal}\n"
    printf "${menu}Make sure you have enough free space, SSD hard drive (recommended) and all masternodes has been stopped before you use any of this option: ${normal}\n"
    printf "${menu}**${number} 7)${menu} Create swap file (extend memory) ${normal}\n"
    printf "${menu}**${number} 8)${menu} Delete swap file ${normal}\n"
    
    printf "${menu}*********************************************${normal}\n"
    printf "Please enter ${fgred}a menu option${normal} (or ${fgred}x${normal} to exit) and press ENTER: "
    read opt
}

print_msg(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal white
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}

get_vps_info(){
    print_msg "VPS IP:";
    printf $(dig +short -4 myip.opendns.com @resolver1.opendns.com)
    printf "\n${menu}*********************************************${normal}\n"

    print_msg "Path for BEAR Coin masternodes:";
    printf "$HOME/BEAR"
    printf "\n${menu}*********************************************${normal}\n"

    print_msg "CPU:";
    lscpu | grep -iE 'model name|vendor id|architecture'
    printf "${menu}*********************************************${normal}\n"

    print_msg "Memory:";
    free -h
    printf "${menu}*********************************************${normal}\n"

    print_msg "Hard drive space:";
    df -h -x squashfs --total
}

get_masternodes_info(){

	noOfMasternodes=$(ls -l $HOME/BEAR/ | grep -c ^d)
	if [[ $noOfMasternodes -eq "0" ]]; then
		print_msg "You don't have installed masternodes yet";
	else
		currentBlock=$(wget https://openchains.info/api/v1/bearcoin/getheight -q -O -)
		print_msg "${fgred}Height (official explorer): $currentBlock${normal}"

		for i in $(ls -d $HOME/BEAR/*/); do 
			fullPath=${i%%/};
			baseName=$(basename $fullPath);

			getBlockCount=`bear-cli -datadir=$fullPath getblockcount 2> /dev/null`
			getInfo=`bear-cli -datadir=$fullPath getinfo  2> /dev/null`
			getMasternodeStatus=`bear-cli -datadir=$fullPath getmasternodestatus  2> /dev/null`

			numberOfConnections=` jq '.connections' <<< "${getInfo}"`

			masternodeStatus=` jq '.status' <<< "${getMasternodeStatus}"`
			if [[ $masternodeStatus -eq "4" ]]; then
				masternodeStatus="Enabled"
      elif [[ -z "$getBlockCount" ]] && [[ -z "$getMasternodeStatus" ]]; then
        getBlockCount="0"
        numberOfConnections="0"
        masternodeStatus="Disabled"
			else
				masternodeStatus="Inactive. Please, start masternode by BEAR Coin Wallet"
			fi

			printf "${fgred}Masternode $baseName:${normal} Height: $getBlockCount \ Connections: $numberOfConnections \ Masternode status: $masternodeStatus\n";
	    done
	fi 
}

install_masternode(){
	noOfMasternodes=$(ls -l $HOME/BEAR/ | grep -c ^d)

	print_msg "Enter masternode alias name (eg.:MN001):"
	read mnAlias

	print_msg "Enter masternode key:"
  	read mnKey

  	if [ ! -f "$HOME/BEAR/bootstrap.zip" ]; then
    	before_installation;
	fi

	unzip "$HOME/BEAR/bootstrap.zip" -d "$HOME/BEAR/$mnAlias/"

	configFile="$HOME/BEAR/$mnAlias/bear.conf"
	port=$(expr $noOfMasternodes + 7171)
	rpcPort=$(expr $noOfMasternodes + 8181)
	ip=$(dig +short -4 myip.opendns.com @resolver1.opendns.com)

	echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` > $configFile
  	echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $configFile
  	echo "rpcallowip=127.0.0.1" >> $configFile
  	echo "rpcport=$rpcPort" >> $configFile
  	echo "port=$port" >> $configFile
  	echo "listen=1" >> $configFile
  	echo "server=1" >> $configFile
  	echo "daemon=1" >> $configFile
  	echo "masternode=1" >> $configFile
  	echo "masternodeaddr=$ip:7171" >> $configFile
  	echo "masternodeprivkey=$mnKey" >> $configFile

  	print_msg "Masternode $mnAlias has been installed. Run $mnAlias masternode now? [y/n]"
  	read runMasternode

  	if [[ $runMasternode =~ "y" ]] ; then
  		beard -datadir="$HOME/BEAR/$mnAlias"
  	fi
}

print_masternode_aliases(){
	noOfMasternodes=$(ls -l $HOME/BEAR/ | grep -c ^d)
	counter=1
	for i in $(ls -d $HOME/BEAR/*/); do 
		fullPath=${i%%/};
		baseName=$(basename $fullPath);
		printf "${fgred}$baseName${normal}";
    counter=$(expr $counter + 1)
		if [[ $counter -le $noOfMasternodes ]]; then
			printf ", ";
		fi
	done
}

before_installation() {
  sudo apt-get update
  sudo apt-get install -y jq unzip 

  sudo ufw allow ssh
  sudo ufw allow 7171
  sudo ufw --force enable

  sudo apt-get install dnsutils

  bearJSON=$(wget https://bearcoin.net/bear.json --no-check-certificate -q -O -)
  walletURL=` jq -r '.mnManager.walletURL' <<< "${bearJSON}"` 
  bootstrapURL=` jq -r '.mnManager.bootstrapURL' <<< "${bearJSON}"` 

  mkdir -p "$HOME/BEAR"

  sudo rm /usr/local/bin/beard /usr/local/bin/bear-cli
  wget $walletURL -O "$HOME/BEAR/temp.zip"
  sudo unzip -j "$HOME/BEAR/temp.zip" "beard" "bear-cli" -d "/usr/local/bin"
  sudo chmod +x /usr/local/bin/bear*
  rm "$HOME/BEAR/temp.zip"

  wget $bootstrapURL -O "$HOME/BEAR/bootstrap.zip"
}

after_installation() {
  rm -f "$HOME/BEAR/bootstrap.zip"
}

delete_masternode(){
	printf "Delete masternode - enter masternode alias ("
  print_masternode_aliases;
  printf ") and press ENTER: "
  read mnAlias
  pkill -f -9 "beard -datadir=$HOME/BEAR/$mnAlias"
  rm -rf "$HOME/BEAR/$mnAlias"
}

start_masternode(){
  printf "Start masternode - enter masternode alias ("
  print_masternode_aliases;
  printf ") and press ENTER: "
  read mnAlias
  beard -datadir="$HOME/BEAR/$mnAlias"
}

stop_masternode(){
  printf "Stop masternode - enter masternode alias ("
  print_masternode_aliases;
  printf ") and press ENTER: "
  read mnAlias
  bear-cli -datadir="$HOME/BEAR/$mnAlias" stop
}

create_swapfile(){
  printf "Enter swap file size in GB (eg.: 1) and press ENTER: "
  read swapSize
  sudo fallocate -l "$swapSize"G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  sudo echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
  sudo swapon --show

}

delete_swapfile(){
  sudo swapoff -v /swapfile
  sudo rm /swapfile
  sudo swapon --show
}


clear
show_menu
while [[ $opt != '' ]]
    do
    if [[ $opt = '' ]]; then
      exit;
    else
      case $opt in
        1)  clear;
            get_vps_info;
            show_menu;
        ;;
        2)  clear;
            get_masternodes_info;
            show_menu;
        ;;
        3)  clear;
            install_masternode;
            show_menu;
        ;;
        4)  clear;
			      delete_masternode;
            show_menu;
        ;;
        5)  clear;
			      start_masternode;
            show_menu;
        ;;
        6)  clear;
			      stop_masternode;
            show_menu;
        ;;
        7)  clear;
            create_swapfile;
            show_menu;
        ;;
        8)  clear;
            delete_swapfile;
            show_menu;
        ;;
        x)	after_installation;
			      exit;
        ;;
        *)	clear;
            print_msg "Pick an option from the menu";
            show_menu;
        ;;
      esac
    fi
done