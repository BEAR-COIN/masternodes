<p align="center"><img src="https://raw.githubusercontent.com/BEAR-COIN/branding/master/img/header.png" /></p>

# BEAR Coin Masternode Setup Guide

## Required:
* **10 000 BEAR Coins**. 
  
* **Local BEAR Coin Wallet** for 
  * [Windows](https://bearcoin.net/go/download/wallet/windows) or 
  * [Linux GNU](https://bearcoin.net/go/download/wallet/linux-gnu) - like: Ubuntu Desktop, Lubuntu, Kali Linux, Debian and many more...
  
* **VPS with Ubuntu Server 16.04** or newer
  * recommended: 1GB RAM / 1 core CPU / 2GB or more free space HDD/SSD
  * you can buy VPS from any trustful hosting provider like: Aruba Cloud, Vultr, Digital Ocean, OVH, etc.
  
* **SSH client**
  * [Putty](https://www.putty.org/) if you use Windows or 
  * default built-in terminal if Linux
  
* **Text editor** on your local pc to save data for copy/paste

## Step 1 : Obtain BEAR coins

Each BEAR Coin Masternode address should contain **10 000 BEAR coins**. To acquire BEAR coins, register and login to [Crex24 Exchange](https://bearcoin.net/go/exchange/crex), deposit bitcoin and buy BEAR Coins.

<p align="center"><img src="https://i.imgur.com/DCjOx2c.gif" /></p>

[Crex24](https://bearcoin.net/go/exchange/crex) is a professional cryptocurrency exchange platform which has been in operation since 2017. The company operates in all countries except for the UK, USA, Canada and Israel. From January 1st, 2020 [Crex24](https://bearcoin.net/go/exchange/crex) require European Union users to go through a KYC process by uploading a valid government ID and their Social Security numbers, so the exchange can comply with the European Anti-money laundry (AML) rules.

* **KYC procedure isn't mandatory for users outside European Union.**
* **Tourists travelling to UK, USA, Canada and Israel still can use Crex24 by VPN** (for example [ZenMate extension for Chrome Browser](https://chrome.google.com/webstore/detail/zenmate-free-vpn–best-vpn/fdcgdnkidjaadafnichfpabhfomcebme) ) and switch to different country (for example Singapore)

## Step 2 : Setup BEAR Coin wallet on desktop/laptop

<p align="center"><img src="https://i.imgur.com/6Rbnina.gif" /></p>

On your desktop/laptop, download the BEAR Coin Wallet file for your OS:
* [Windows](https://bearcoin.net/go/download/wallet/windows) or 
* [Linux GNU](https://bearcoin.net/go/download/wallet/linux-gnu)

Extract to a location of your choice. For this guide we'll extract bear-qt executable file to path ```c:\bear``` Once you do, double click and start **bear-qt** 

On the first run, BEAR Coin Wallet prompts you to choose a location to store the blockchain files. Please choose a location of your choice which has sufficient storage space. 

In this guide we'll use path ```C:\bear\blockchain```

The wallet will also prompt you to allow access to internet via the firewall (Windows only). Click OK to allow access.

Once you open your wallet, it will take a few minutes for synchronisation. **Kindly wait till it is completely synchronised.**

----------
**Optional:**
In time, blockchain will be getting bigger and first synchronization may take hours. In this case, you can speed-up synchronization by following steps: 
* close BEAR Coin Wallet, 
* download [current blockchain bootstrap](https://bearcoin.net/go/download/wallet/bootstrap), 
* extract files from zip bootstrap file to a location of your blockchain folder (in this case you can delete all other existing files from blockchain folder and keep only extracted files from bootstrap).
* run **bear-qt** again.
----------

## Step 3: Obtain a VPS (Virtual Private Server)

To run own masternode you need to have the virtual private server which needs to be up and running and online 24x7 to be part of the BEAR Coin masternode network.

In this guide we'll use Google Cloud VPS. You can sign-up for a free Google Cloud VPS https://cloud.google.com/free/ . You will need to provide your credit / debit card to activate your account. Once you do this, you are credited with 300 USD worth of credits. That amount is valid for more than 1 year and sufficient to run an Ubuntu Linux Virtual Private Server with the default 2 GB RAM, 20 GB SSD and 2 vCPU. This VPS configuration is more than enough to run the single BEAR masternode, infact you can run even 10 BEAR Coin masternodes on this VPS.

If you have already used up Google Cloud credits or can’t get one, the next best option is to get a VPS server, which costs usually around 5$ per month. You can buy VPS from any trustful hosting provider like: Aruba Cloud, Vultr, Digital Ocean, OVH, etc... 

<p align="center"><img src="https://i.imgur.com/FV8dPsx.gif" /></p>

Once your Google Cloud account and credits is active, you can open https://console.cloud.google.com/ and create VPS:

* select from menu: **Compute Engine -> VM instances** and click **Create**
* change **instance name** (eg. bear-1)
* select **machine type** (eg. 2 vCPU, 2 GB memory)
* change **boot disk** parameters: **Size** (eg. 20 GB), **Boot disk type** (we recommend SSD), **Operating system -> Ubuntu** and click **Select** button
* take a look at price -  make sure your configuartion will not consume all credits too fast. Price depends on VPS location (region), machine configuaration parameters and hard drive type/size
* scroll down page and click **Create** button

## Step 4: Prepare BEAR Coin wallet

### Step 4.1: Disable staking
<p align="center"><img src="https://i.imgur.com/Z5XlW2K.gif" /></p>

* go to menu: **Tools -> Open Wallet Configuration File** 
* enter ```staking=0```
* save file
* restart BEAR Coin Wallet (menu: **File -> Exit** and run **bear-qt** again)

### Step 4.2: Prepare wallets
<p align="center"><img src="https://i.imgur.com/U5yPoLZ.gif" /></p>

* go to menu: **File -> Receiving addresses**
* double click on ```(no label)```, change label name to ```MAIN``` and press **ENTER**
* close BEAR Coin Wallet (menu: **File -> Exit**)
* open blockchain folder and change wallet.dat filename to **MAIN.dat**
* run **bear-qt** again
* go to menu: **File -> Receiving addresses**
* double click on ```(no label)```, change label name to ```MN001``` and press **ENTER**

----------
**Note:** In this guide we'll create a two BEAR Coin masternodes (20 000 BEAR Coins). If you want to created more masternodes, then repeat to generate more addresses (keep labels format: MN003 ... MN010 ... MN099 ... MN100)
* click **New** Button
* entel label ```MN002``` and click **OK**
----------

* close BEAR Coin Wallet (menu: **File -> Exit**)
* open blockchain folder and change wallet.dat filename to **MASTERNODES.dat**

**MAIN.dat** contain a single BEAR Coin wallet addres:
* ```MAIN``` - useful for any in/out transaction

**MASTERNODES.dat** contain a two BEAR Coin wallet addreses:
* ```MN001``` - we'll deposit 10 000 BEAR coins here
* ```MN002``` - we'll deposit 10 000 BEAR coins here

### Step 4.3: Create shortcuts (Windows)
<p align="center"><img src="https://i.imgur.com/2yXKQEE.gif" /></p>

* open location of your bear-qt file (eg. ```c:\bear```)
* create shortcut of bear-qt file, rename shortcut to **BEAR[MAIN]** and move to dektop
* select properties of **BEAR[MAIN]** shortcut
* in **Target** section enter: ```C:\bear\bear-qt.exe -wallet=MAIN.dat```

Repeat to create **BEAR[MASTERNODES]** shortcut:

* open location of your bear-qt file (eg. ```c:\bear```)
* create shortcut of bear-qt file, rename shortcut to **BEAR[MASTERNODES]** and move to dektop
* select properties of **BEAR[MASTERNODES]** shortcut
* in **Target** section enter: ```C:\bear\bear-qt.exe -wallet=MASTERNODES.dat```

### Step 4.4: Backup and security
We strongly recommend to make a backup every time you create a new wallet address. You can simply copy files (**MAIN.dat** ,  **MASTERNODES.dat** and **masternode.conf**) to external USB storage device. 

Another option is backup of private keys of every wallet address and print. That way you will be able to restore your wallet addresses and coins even if you loose external USB storage device and your computer/hard drive will be damaged.

<p align="center"><img src="https://i.imgur.com/AX9kJVT.gif" /></p>

* Open BEAR Coin Wallet by shortcut **BEAR[MAIN]**
* go to menu: **Tools -> Debug console**
* enter command: ```dumpprivkey YOUR_WALLET_ADDRESS``` and press **ENTER**
* you will see on screen private key, copy that and paste to notepad. 
* close BEAR Coin wallet (menu: **File -> Exit**)

To check ```YOUR_WALLET_ADDRESS``` - Go to menu: **File -> Receiving addresss**

Repeat with **BEAR[MASTERNODES]** for every masternode wallet address (```MN001``` ```MN002``` etc..)

Print and/or save your text file on external USB storage device. **Don't keep private keys on pc/online/cloud storage for safety reasons.**

**Never share private keys and wallet files** (MAIN.dat and MASTERNODES.dat) with anyone - even BEAR Coin team members! **Every request of private key is scam attempt, you can loose all your coins.** In cryptocurrency world you are your own bank. Safety of your wallet files and private keys is your responsibility.

Optionally you can also encrypt both wallets - **MAIN.dat** and **MASTERNODES.dat**. Go to menu: **Settings -> Encrypt Wallet**, fill out form and follow instructions. **Warning: If you'll not remember your passphrase and you'll not have private keys then you'll loose coins!**

### Step 4.5: Withdraw Coins from exchange
Now, head to [Crex24](https://bearcoin.net/go/exchange/crex) exchange and **let's withdraw coins to MAIN wallet address**. For this, click on the **ACCOUNT** in the exchange window. Find BEAR Coin on list of all coins. Then click on **Withdraw icon/button**. Fillout form and click **Withdraw** button.

<p align="center"><img src="https://i.imgur.com/t8ruZZz.gif" /></p>

Open your email and confirm withdraw. If all went well, you should now have BEAR Coin wallet. Note: [Crex24](https://bearcoin.net/go/exchange/crex) exchange takes fee of every withdrawal. Fee will be deducted from your Crex24 balance.

### Step 4.6: Send coins to masternodes 

<p align="center"><img src="https://i.imgur.com/QSsKC9z.gif" /></p>

* open BEAR Coin Wallet by shortcut **BEAR[MASTERNODES]**
* go to menu: **File -> Receiving addresses**, copy masternode addresses and paste to notepad
* close wallet window and then open again BEAR Coin Wallet by shortcut **BEAR[MAIN]**
* go to **Send** tab, enter MN001 address, enter amount (exactly 10000 BEAR coins) and click **Send** button to proceed 
* wait (until rest of coins will show up in balance) and then repeat for MN002
* close BEAR Coin wallet (menu: **File -> Exit**)

### Step 4.7: Prepare masternodes config file

<p align="center"><img src="https://i.imgur.com/pu0YBmc.gif" /></p>

* open BEAR Coin Wallet by shortcut **BEAR[MASTERNODES]**
* go to menu: **Tools > Open Masternode Configuration File**

In this file add a new lines in the following format:

```
MN001 VPS_IP::7171 MASTERNODE_KEY OUTPUT_TXID OUTPUT_INDEX
MN002 VPS_IP::7171 MASTERNODE_KEY OUTPUT_TXID OUTPUT_INDEX
```

To generate ```MASTERNODE_KEY```:
* go to menu: **Tools -> Debug console**
* enter command: ```createmasternodekey``` and press **ENTER**
* repeat for MN002, next copy both keys and paste to masternode configuration text file

To get ```OUTPUT_TXID``` and ```OUTPUT_INDEX```:
* go to menu: **Tools -> Debug console**
* enter command: ```getmasternodeoutputs``` and press **ENTER**
* copy all values and paste to masternode configuration text file
* save text file and close BEAR Coin wallet (menu: **File -> Exit**)

Note: ```OUTPUT_TXID``` will be your transaction id for coins sent to ```MN001``` or ```MN002``` and can be checked in transactions history of masternode wallet.

## Step 5: Run masternodes

### Step 5.1: BEAR Coin Multi Masternodes Manager

<p align="center"><img src="https://i.imgur.com/nJQYivW.gif" /></p>

Login to your VPS by SSH client (eg. Putty - Windows or Terminal - Linux). In this guide we use Google Cloud and we can login via browser.

Install and run BEAR Coin Multi Masternodes Manager by following commands:

```wget https://raw.githubusercontent.com/BEAR-COIN/masternodes/master/masternodes-manager.sh```

```sudo chmod +x masternodes-manager.sh```

```./masternodes-manager.sh```

When you will see BEAR Coin Multi Masternodes Manager menu:

* select ```3``` from menu to run installation masternode process
* enter alias (eg ```MN001```)
* enter ```MASTERNODE_KEY``` for MN001 same like in **masternode.conf** file
* installation will be finished soon, wait for that and then enter ```y``` to run masternode on your VPS

After all you will see Masternodes Manager menu again. Select ```3``` and repeat last steps for ```MN002```

Anytime you can check current status of masternodes by option ```2```

### Step 5.2: Start masternodes

<p align="center"><img src="https://i.imgur.com/mp3GoUL.gif" /></p>

In final steps you will activate masternodes in BEAR Coin Wallet on your PC/laptop:

* open BEAR Coin Wallet by shortcut **BEAR[MASTERNODES]**
* go to **Masternodes** tab
* select masternode ```MN001``` and click **Start alias**
* repeat for masternode ``MN002```

CONGRATULATIONS! Your BEAR Coins Masternodes are up and running now. You can confirm that in Masternodes Manager: option ```2```, every masternode should have **status: Enabled** First masternodes rewards will appear after 24 hours in **BEAR[MASTERNODES]** wallet.

In case additional questions join [BEAR Coin Discord](https://bearcoin.net/go/discord). Additional informations about our coin you can also find on [BEAR Coin](https://bearcoin.net) website.

