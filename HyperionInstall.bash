#!/bin/sh
# Script for installing Hyperion.NG or HyperHDR release on many Raspberry Pi Operating System

#Set welcome message
echo '*******************************************************************************' 
echo 'This script will install Hyperion.NG or HyperHDR on LibreELEC and Raspberry Pi OS ( or other system )'
echo ''
echo 'Created by brindosch and modified by Paulchen-Panther (thanks to horschte from kodinerds)'
echo 'hyperion-project.org - the official Hyperion source'
echo ''
echo 'Modified by AmbiMod to have some new features'
echo ''
echo 'Corrected by Neeeb for the installation of HyperHDR v17 on LibreELEC'
echo ''
echo ''
echo 'Adding install of Hyperion NG or HyperHDR on x86_CPU and possibility to install 64 bits version'
echo '*******************************************************************************'


# Verification que nous sommes sur LibreELEC
OS_LIBREELEC=`grep -m1 -c LibreELEC /etc/issue`

# Verification du type de Processeur pour savoir si nous sommes en presence d'un Raspberry Pi ou d'un ordinateur x86_64
CPU_RPI=`grep -m1 -c 'BCM2708\|BCM2709\|BCM2710\|BCM2835\|BCM2836\|BCM2837\|BCM2711' /proc/cpuinfo`
CPU_x86_64=`grep -m1 -c 'Intel\|AMD' /proc/cpuinfo`

# Recuperation du modele de Raspberry Pi
RPI_1=`grep -m1 -c 'BCM2708' /proc/cpuinfo`
RPI_2_3_4=`grep -m1 -c 'BCM2709\|BCM2710\|BCM2835\|BCM2836\|BCM2837\|BCM2711' /proc/cpuinfo`
RPI_3_4_64BITS=`grep -m1 -c 'aarch64' /proc/version`
Intel=`grep -m1 -c 'Intel' /proc/cpuinfo`
AMD=`grep -m1 -c 'AMD' /proc/cpuinfo`

# Recuperation du script init à utiliser
USE_SYSTEMD=`grep -m1 -c systemd /proc/1/comm`

# Verification de la non-execution du deamon boblight
BOBLIGHT_PROCNR=$(pidof boblightd | wc -l)
if [ $BOBLIGHT_PROCNR -eq 1 ]; then
    echo "---> Erreur critique : Une instance de Boblight est en cours d'execution. Priere de l'arreter dans le menu de Kodi avant d'installer Hyperion -> Annulation."
    exit 1
fi

OLDCONFIG=""
OTHEROS_HYPERIONFILE_RPI1=Linux-armv6l.deb
OTHEROS_HYPERIONFILE_RPI234=Linux-armv7l.deb
OTHEROS64_HYPERIONFILE_RPI34=Linux-aarch64.deb
LIBREELEC_HYPERIONFILE_RPI1=Linux-armv6l.tar.gz
LIBREELEC_HYPERIONFILE_RPI234=Linux-armv7l.tar.gz
CPU_X86_64_HYPERIONFILE=Linux-x86_64.deb

#Verification de la presence de dtparam=spi=on dans config.txt sur libreELEC
Verif_dtparam()
{
if [ $OS_LIBREELEC -ne 0 ]; then
	if [ $CPU_RPI -eq 1 ]; then
		SPIOK=`grep '^\dtparam=spi=on' /flash/config.txt | wc -l`
			if [ $SPIOK -ne 1 ]; then
				mount -o remount,rw /flash
				echo '---> LibreELEC tournant sur Raspberry trouvé mais "dtparam=spi=on" est absent de /flash/config.txt. Rajout de ce parametre de configuration.'
				sed -i '$a dtparam=spi=on' /flash/config.txt
				mount -o remount,ro /flash
				REBOOTMESSAGE='Veuillez redemarrer votre Pi afin que la ligne dtparam=spi=on copié dans le fichier config.txt soit prise en compte.'
			fi
	fi
fi
}

Uninstall_Hyperion()
{
if sudo dpkg-query -l | grep hyperion; then
	echo ""
	echo "Version d'Hyperion detecté. Desinstallation de la version existante d'Hyperion avant installation d'$HYPERIONFILE."
	echo ""
	sudo dpkg --remove hyperion
	OLDINSTALL=hyperion
else
	if sudo dpkg-query -l | grep hyperhdr; then
	echo ""
	echo "Version d'HyperHDR detecté. Desinstallation de la version existante d'HyperHDR avant installation d'$HYPERIONFILE."
	echo ""
	sudo dpkg --remove hyperhdr
	OLDINSTALL=hyperhdr
	fi
fi
}

Verif_Dependences()
{
echo ""
echo "Installation des dependences si neccessaire."
if apt list libglvnd0 cec-utils | awk -F "/" '{ $2 = "" ; print $0 }' > list.txt; then
	packages=$(cat list.txt)
	grep -q '[^[:space:]]' < list.txt
	sudo apt-get install -y $packages
	rm list.txt
fi
}

Source_HyperionNG()
{
HYPERION_DOWNLOAD_URL="https://github.com/hyperion-project/hyperion.ng/releases/download"
HYPERION_RELEASES_URL="https://api.github.com/repos/hyperion-project/hyperion.ng/releases"
HYPERION_LATEST_VERSION=$(curl -sL "$HYPERION_RELEASES_URL" | grep "tag_name" | head -1 | cut -d '"' -f 4)
HYPERIONVERSION=Hyperion
}

Source_HyperHDR()
{
HYPERION_DOWNLOAD_URL="https://github.com/awawa-dev/HyperHDR/releases/download"
HYPERION_RELEASES_URL="https://github.com/awawa-dev/HyperHDR/releases"
HYPERION_LATEST_VERSION=$(curl -sLo /dev/null -w '%{url_effective}' github.com/awawa-dev/HyperHDR/releases/latest | cut -d 'v' -f 3)
HYPERION_LATEST_VERSIONv=$(curl -sLo /dev/null -w '%{url_effective}' github.com/awawa-dev/HyperHDR/releases/latest | cut -d '/' -f 8)
HYPERIONVERSION=HyperHDR
}

Installation_64bits_HDR()
{
Source_HyperHDR
if [ $CPU_x86_64 -eq 1 ]; then
echo "Installation d'HyperHDR sur un CPU 32 ou 64 bits."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSIONv/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$CPU_X86_64_HYPERIONFILE
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$CPU_X86_64_HYPERIONFILE
else
echo "Installation d'HyperHDR sur Raspberry Pi OS qui tourne sur un Raspberry AARCH64."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSIONv/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS64_HYPERIONFILE_RPI34
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS64_HYPERIONFILE_RPI34
fi
}

Installation_64bits_NG()
{
Source_HyperionNG
if [ $CPU_x86_64 -eq 1 ]; then
    echo "Installation d'Hyperion NG sur un CPU 32 ou 64 bits."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSION/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$CPU_X86_64_HYPERIONFILE
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$CPU_X86_64_HYPERIONFILE
else	
	echo "Installation d'Hyperion NG sur Raspberry Pi OS qui tourne sur un Raspberry AARCH64."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSIONv/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS64_HYPERIONFILE_RPI34
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS64_HYPERIONFILE_RPI34
fi
}

Installation_HyperHDR_AutreOS()
{
Source_HyperHDR
if [ $RPI_1 -eq 1 ]; then
	echo "Installation d'HyperHDR sur Raspberry Pi OS qui tourne sur un Raspberry ARM v6."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSIONv/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS_HYPERIONFILE_RPI1
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS_HYPERIONFILE_RPI1
elif [ $RPI_3_4_64BITS -eq 1 ]; then
    echo "Installation d'HyperHDR sur Raspberry Pi OS qui tourne sur un Raspberry AARCH64."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSIONv/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS64_HYPERIONFILE_RPI34
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS64_HYPERIONFILE_RPI34
elif [ $RPI_2_3_4 -eq 1 ]; then
    echo "Installation d'HyperHDR sur Raspberry Pi OS qui tourne sur un Raspberry ARM v7."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSIONv/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS_HYPERIONFILE_RPI234
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS_HYPERIONFILE_RPI234
elif [ $CPU_x86_64 -eq 1 ]; then
echo "Installation d'HyperHDR sur un CPU 32 ou 64 bits."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSIONv/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$CPU_X86_64_HYPERIONFILE
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$CPU_X86_64_HYPERIONFILE
fi
}

Installation_HyperHDR_LibreELEC()
{
Source_HyperHDR
if [ $RPI_1 -eq 1 ]; then
    echo "Installation d'HyperHDR sur LibreELEC qui tourne sur un Raspberry ARM v6."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSIONv/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$LIBREELEC_HYPERIONFILE_RPI1
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$LIBREELEC_HYPERIONFILE_RPI1
elif [ $RPI_2_3_4 -eq 1 ]; then
    echo "Installation d'HyperHDR sur LibreELEC qui tourne sur un Raspberry ARM v7."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSIONv/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$LIBREELEC_HYPERIONFILE_RPI234
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$LIBREELEC_HYPERIONFILE_RPI234
fi
}

Installation_HyperNG_LibreELEC()
{
Source_HyperionNG
if [ $RPI_1 -eq 1 ]; then
    echo "Installation d'Hyperion NG sur LibreELEC qui tourne sur un Raspberry ARM v6."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSION/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$LIBRELEC_HYPERIONFILE_RPI1
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$LIBREELEC_HYPERIONFILE_RPI1
elif [ $RPI_2_3_4 -eq 1 ]; then
    echo "Installation d'Hyperion NG sur LibreELEC qui tourne sur un Raspberry ARM v7."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSION/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$LIBREELEC_HYPERIONFILE_RPI234
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$LIBREELEC_HYPERIONFILE_RPI234
fi
}

Installation_HyperNG_AutreOS()
{
Source_HyperionNG
if [ $RPI_1 -eq 1 ]; then
	echo "Installation d'Hyperion NG sur un autre systeme que LibreELEC qui tourne sur un Raspberry ARM v6."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSION/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS_HYPERIONFILE_RPI1
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS_HYPERIONFILE_RPI1
elif [ $RPI_3_4_64BITS -eq 1 ]; then
	echo "Installation d'Hyperion NG sur Raspberry Pi OS qui tourne sur un Raspberry AARCH64."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSIONv/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS_HYPERIONFILE_RPI34
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS_HYPERIONFILE_RPI34	
elif [ $RPI_2_3_4 -eq 1 ]; then
    echo "Installation d'Hyperion NG sur un autre systeme que LibreELEC qui tourne sur un Raspberry ARM v7."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSION/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS_HYPERIONFILE_RPI234
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$OTHEROS_HYPERIONFILE_RPI234
elif [ $CPU_x86_64 -eq 1 ]; then
    echo "Installation d'Hyperion NG sur un CPU 32 ou 64 bits."
    HYPERION_RELEASE=$HYPERION_DOWNLOAD_URL/$HYPERION_LATEST_VERSION/$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$CPU_X86_64_HYPERIONFILE
    HYPERIONFILE=$HYPERIONVERSION-$HYPERION_LATEST_VERSION-$CPU_X86_64_HYPERIONFILE
fi
}

Installation_LibreELEC()
{
if [ ! -z "$OLDINSTALL" ]; then
	echo ""
	echo "Suppression de l'ancien dossier hyperion et desactivation du service."
	systemctl disable $OLDINSTALL.service --now
	rm -R /storage/$OLDINSTALL
fi

if [ $1 -eq 1 ]; then
	CIBLE=hyperhdr
else
	CIBLE=hyperion
fi

if [ -f $HYPERIONFILE ]; then
	echo ""
	echo "---> Installation de $HYPERIONFILE qui se trouve localement."
    tar -xzf $HYPERIONFILE --strip-components=1 -C /storage share/$CIBLE/
	Script_Hyperion_LibreELEC
else
	echo ""
    echo "---> Telechargement et installation de $HYPERIONFILE"
    curl -# -L --get $HYPERION_RELEASE | tar --strip-components=1 -C /storage share/$CIBLE -xz
    Script_Hyperion_LibreELEC
fi
}

Installation_AutreOS()
{
if [ -f $HYPERIONFILE ]; then
	echo ""
    echo "---> Installation de $HYPERIONFILE qui se trouve localement."
    sudo dpkg -i $HYPERIONFILE
else
	echo ""
    echo "---> Telechargement et installation de $HYPERIONFILE"
    wget $HYPERION_RELEASE && sudo dpkg -i $HYPERIONFILE
fi
}

Script_Hyperion_LibreELEC()
{
# Suppression des dependences inutile sur la version Alpha 7
if [ "$HYPERION_LATEST_VERSION" = "2.0.0-alpha.7" ]; then
	rm /storage/hyperion/lib/libcec*
	rm /storage/hyperion/lib/libz*
fi

# Activation des droits d'execution
chmod +x -R /storage/$CIBLE/bin

# Creation du service

if [ "$HYPERION_LATEST_VERSION" = "17.0.0.0" ]; then
DAEMON=hyperhdr
else
DAEMON=hyperiond
fi

echo "---> Installation du script dans system.d"
SERVICE_CONTENT="[Unit]
Description=Hyperion ambient light systemd service
After=network.target
[Service]
Environment=DISPLAY=:0.0
ExecStart=/storage/$CIBLE/bin/$DAEMON --userdata /storage/$CIBLE/
TimeoutStopSec=2
Restart=always
RestartSec=10

[Install]
WantedBy=default.target"

# Mise en place et activation du service hyperion
echo "$SERVICE_CONTENT" > /storage/.config/system.d/$CIBLE.service
systemctl -q enable $CIBLE.service --now
echo "*******************************************************************************"
echo "Installation d'Hyperion / HyperHDR terminé !"
echo "*******************************************************************************"
Verif_dtparam
echo $REBOOTMESSAGE
exit 0
}

choix=0
while [ "$choix" -eq 0 ]; do
	echo '*******************************************************************************'
	echo "Script d'installation d'HyperHDR / d'Hyperion NG"
	echo "Quelle version d'Hyperion voulez-vous installer ? "
	echo "1. Pour HyperHDR, Tapez 1"
	echo "2. Pour Hyperion NG, Tapez 2"
	echo "3. Pour HyperHDR 64 bits, Tapez 3"
	echo "4. Pour Hyperion NG 64 bits, Tapez 4"
	echo '*******************************************************************************'
	read -r choix
	case "$choix" in
        1)
        if [ $OS_LIBREELEC -ne 0 ]; then
			Uninstall_Hyperion
			Installation_HyperHDR_LibreELEC
			Installation_LibreELEC 1
		else
			Verif_Dependences
			Uninstall_Hyperion
			Installation_HyperHDR_AutreOS
			Installation_AutreOS
        fi;;

        2)
		if [ $OS_LIBREELEC -ne 0 ]; then
			Uninstall_Hyperion
			Installation_HyperNG_LibreELEC
			Installation_LibreELEC 2
        else
			Verif_Dependences
			Uninstall_Hyperion
			Installation_HyperNG_AutreOS
			Installation_AutreOS
        fi;;

		3)
		if [ $OS_LIBREELEC -ne 0 ]; then
			Uninstall_Hyperion
			Installation_64bits_HDR
			Installation_LibreELEC 1
		else
			Verif_Dependences
			Uninstall_Hyperion
			Installation_64bits_HDR
			Installation_AutreOS
        fi;;

		4)
		if [ $OS_LIBREELEC -ne 0 ]; then
			Uninstall_Hyperion
			Installation_64bits_NG
			Installation_LibreELEC 1
		else
			Verif_Dependences
			Uninstall_Hyperion
			Installation_64bits_NG
			Installation_AutreOS
        fi;;

        *)
		echo ""
        echo "Mauvais choix. Entrez soit 1, 2, 3 ou 4."
		echo ""
        sh HyperionInstall.bash
    esac
done