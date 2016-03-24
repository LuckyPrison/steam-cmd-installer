
#!/bin/bash

## Change insdir="$PWD" if you want to use the script folder
insdir="$1"
user=""
pass=""
dir=""
appid=""
appmod=""
bool=""
chkhash=""
archit=""
file="steamcmd.sh"
clear
echo checking update
rm -rf /home/$USER/cmdup
git clone https://github.com/Gousaid67/steam-cmd-installer /home/$USER/cmdup

cmp -s $0 /home/$USER/cmdup/steamcmdinstaller3.8.sh > /dev/null
if [ $? -eq 1 ]; then
 
 echo -a updating....
 mkdir /home/$USER/oldsh
 mv $0 /home/$USER/oldsh
 rm steamcmdinstaller3.8.sh
 mv /home/$USER/cmdup/steamcmdinstaller3.8.sh /home/$USER/
 rm -rf /home/$USER/cmdup
 chmod 755 steamcmdinstaller3.8.sh
 ./steamcmdinstaller3.8.sh
else
    rm -rf /home/$USER/cmdup
    
    echo you are up to date
fi

function getInput()
{
  local rez=""
  echo ------- $1 -------
  read -r rez
  while [ -z "$rez" ]; do
    echo ------ Please put $2 ------
    read -r rez
  done
  eval "$3=$rez"
}
clear
echo --------- do you wish install steamcmd and a server or update/backup your server? instal or maint ------------
select mai in "Maintenance" "Install"; do
    case $mai in
        Maintenance ) mai=1 
                     break ;;
        Install ) mai=0 
                      break ;;
    esac
done
if test "$mai" == "1"
then
 sudo apt-get install git 
 
 rm -rf servermaintenance.sh
 mv  /home/$USER/cmdup/servermaintenance.sh /home/$USER/
 chmod +x servermaintenance.sh
 rm -rf home/$USER/cmdup
  clear 
 
 ./servermaintenance.sh
 exit
fi

echo ------------ This script installs SteamCMD dedicated servers ------------

echo ------- Do you want to install dependencies ? [y or n] -------
read -r bool
if test "$bool" = "y"
then
  archit=$(uname -m)
  echo ------- You are using $archit linux kernel -------
  if [[ "$archit" == "x86_64" ]]; then
    sudo dpkg --add-architecture i386
    sudo apt-get update
    sudo apt-get install lib32gcc1
    sudo apt-get install lib32stdc++6
  else
    sudo apt-get install lib32gcc1
  fi
fi

if [ -n "$insdir" ]; then
  echo ------- Making directory /steamcmd at $insdir -------
else
  echo ------- Making directory /steamcmd at /home/$USER -------
  insdir="/home/$USER"
fi

# Making a directory and switching into it
mkdir $insdir/steamcmd
cd $insdir/steamcmd

echo ------- Downloading steam -------
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz 

chkhash=$(md5sum steamcmd_linux.tar.gz | cut -d' ' -f1)
if test "$chkhash" == "09e3f75c1ab5a501945c8c8b10c7f50e" 
then
  echo ----- Checksum OK -------
else
  echo ----- Checksum FAIL ------- $chkhash
  exit 0
fi

tar -xvzf steamcmd_linux.tar.gz 

# Make it executable
if [[ -x "$file" ]]
then
  echo steamcmd.sh is executable
else
 echo $file is not executable or not found,checking if it exist at the $insdir/steamcmd
 if [ -f "$file" ] 
 then
  echo file found giving it permission
  chmod +x steamcmd.sh
 else
  echo File not found, do you wish to redownload steamcmd? y or n
  read -r redown
  while [ -z "$redown" ]; do
   echo ------ Please give an awnser ------
   read -r redown
  done
  if test "$redown" == "y"
  then 
   echo ------- Downloading steam -------
   wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz 

   chkhash=$(md5sum steamcmd_linux.tar.gz | cut -d' ' -f1)
   if test "$chkhash" == "09e3f75c1ab5a501945c8c8b10c7f50e" 
   then
    echo ----- Checksum OK -------
    tar -xvzf steamcmd_linux.tar.gz 
   else
    echo ----- Checksum FAIL ------- $chkhash
    exit 1
    if [[ -x "$file" ]]
    then
     echo --------steamcmd.sh is executable----------
    else
     chmod +x steamcmd.sh
    fi
   fi
  fi
 fi
 fi
echo ------- Do you wish to install a game now ? [y or n] -------
read -r bool
   
if test "$bool" == "y"
then
  getInput "Enter a user for steam, or login as anonymous" "user name" user
else
  echo ------- Running steam update check -------
  ./steamcmd.sh +quit
  exit 0
fi

if test "$user" == "anonymous"
then
  getInput "Which appid you wish to install ?" "appid" appid
  if test "$appid" == "90"
  then # https://developer.valvesoftware.com/wiki/Dedicated_Servers_List
    echo "Do you need to install a mod for HL1 / CS1.6 ? [no or <mod_name>]"
    select appmod in "HL1" "CS1.6" "no"; do
    case $appmod in
        CS1.6 ) appmod=CS1.6 
                     break ;;
        HL1 ) appmod=HL1 
                      break ;;
        no ) appmod=no 
                      break ;;
     esac
    done
  fi
  getInput "Where in [$insdir] do you want to put it ?" "path" dir
  mkdir $insdir/$dir
  if test "$appmod" == "no"
  then
    ./steamcmd.sh +login $user +force_install_dir $insdir/$dir +app_update $appid validate +quit
  else
    ./steamcmd.sh +login $user +force_install_dir $insdir/$dir +app_update $appid validate +app_set_config "90 mod $appmod" +quit
  fi
else
  getInput "What is the password for the user [$user] ?" "password" pass
  getInput "Which appid you wish to install ?" "appid" appid
  if test "$appid" == "90"
  then # https://developer.valvesoftware.com/wiki/Dedicated_Servers_List
    echo "Do you need to install a mod for HL1 / CS1.6 ? [no or <mod_name>]" "a mod" appmod
    select appmod in "HL1" "CS1.6" "no"; do
    case $appmod in
        CS1.6 ) appmod=CS1.6 
                     break ;;
        HL1 ) appmod=HL1 
                      break ;;
        no ) appmod=no 
                      break ;;
     esac
    done
  fi
  getInput "Where in [$insdir] do you want to put it ?" "path" dir
  mkdir $insdir/$dir
  if test "$appmod" == "no"
  then
    rm -rf /home/$USER/cmdup
    ./steamcmd.sh +login $user $pass +force_install_dir $insdir/$dir +app_update $appid validate +quit
  else
    rm -rf /home/$USER/cmdup
    ./steamcmd.sh +login $user $pass +force_install_dir $insdir/$dir +app_update $appid validate +app_set_config "90 mod $appmod" +quit
  fi
fi

exit 0 
