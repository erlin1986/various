!/bin/bash

#backup folders
backupDir=~/linux/backup"
configBackupDir="$backupDir/hiddenconfig"
zipBackupDir="$backupDir/zipconfig"
scriptBackupDir="$backupDir/scripts"

backupDirs=("$backupDir","$configBackupDir","$zipBackupDir","$scriptBackupDir")

# Make sure we have connection to Ubuntu One
if [ -s ~/'backupDir' ] ; then
	echo "Found Ubuntu bck directory."
	IFS=","
	for bdir in ${backupDirs[@]}
	do
		if [ -s $bdir ] ; then
			printf "Backup directory %s found \n" "$bdir"
		else
			printf "Backup directory %s not found, creating... \n" "$bdir"
			#mkdir -pv $bdir
		fi
	done
else
    echo "You do not have a Ubuntu One folder at ~/Ubuntu bck! Install Ubuntu One. Aborting..."
    exit 0
fi

#conf files
files=( ~/.bashrc
~/.bash_aliases
~/.vimrc
~/.taskrc
/etc/fstab
/boot/grub/grub.cfg
/etc/apt/sources.list
/etc/hosts )

for file in ${files[@]}
do
	cp -fv $file $configBackupDir/
done

dpkg --get-selections | awk '{print $1}' > $configBackupDir/installedPackages.txt

#scripts - self backup!
cp -vrf ~/applications/scripts/* $scriptBackupDir/

#folders
#apt directory
tar cf /tmp/apt-sources.tar /etc/apt/sources.list.d --checkpoint
mv -vf /tmp/apt-sources.tar $zipBackupDir/
#emesene
#tar cf /tmp/emesene.tar ~/.config/ --checkpoint --exclude *cache*
#mv -vf /tmp/emesene.tar $zipBackupDir/
