#/bin/bash
rm /usr/local/bin/beard /usr/local/bin/bear-cli
rm -r .bear/

clear
echo "Do install BEAR Masternode? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then

  # Install depedencies
  sudo apt-get update
  sudo apt-get install -y jq unzip 

  # Config firewall
  sudo ufw allow ssh
  sudo ufw allow 7171
  sudo ufw --force enable

  # Download files
  bearJSON=$(wget https://bearcoin.net/bear.json --no-check-certificate -q -O -)
  walletURL=` jq -r '.mnManager.walletURL' <<< "${bearJSON}"` 
  bootstrapURL=` jq -r '.mnManager.bootstrapURL' <<< "${bearJSON}"` 

  wget $walletURL -O temp.zip
  sudo unzip -j "temp.zip" "beard" "bear-cli" -d "/usr/local/bin"
  sudo chmod +x /usr/local/bin/bear*
  rm temp.zip

  wget $bootstrapURL -O temp.zip
  unzip "temp.zip" -d ".bear/"
  rm temp.zip

  # Config files
  configFile="$HOME/.bear/bear.conf"
  port=7171
  rpcPort=8181
  ip=$(dig +short myip.opendns.com @resolver1.opendns.com)

  echo "Enter masternode private key: (How to get masternode private key? Go to your Local Wallet on PC, then menu: Tools > Debug Console, then type: createmasternodekey and hit ENTER on keyboard"
  read privKey

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
  echo "masternodeprivkey=$privKey" >> $configFile

  beard
fi