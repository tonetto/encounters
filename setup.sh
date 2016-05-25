#!/bin/bash

## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License
## version 2 as published by the Free Software Foundation.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
##
## author: Leonardo Tonetto

function setup_linux
{
    echo "Found the following Wireless interfaces:"
    for intrfc in `sudo iw dev | grep Interface | awk '{print $2}'`; do echo $intrfc; done
    
    echo "[setup] Checking/Installing required packages"
    ## Check if tcpdump and iw are installed [elegant way...]
    type -P tcpdump >/dev/null && type -P iw >/dev/null && return
    ## Manually check for these guys [ugly way...]
    [ -x "/usr/sbin/tcpdump" -o -x "/usr/bin/tcpdump" ] && [ -x "/sbin/iw" ] && return
    ## Install it otherwise
    # Ubuntu/Debian based distros
    [ -x "/usr/bin/apt-get" ] && sudo apt-get install tcpdump iw && return
    # Arch based distros
    [ -x "/usr/bin/pacman" ] && sudo pacman -S tcpdump iw && return
    ## Could not install and could not find it, suggest manual install
    echo "Please install manually tcpdump and run it with --skip-install"
    exit 2
}

function setup_macos
{
    echo "Found the following Wireless interfaces:"
    networksetup listallhardwareports | grep "Wi-Fi" -A1 | grep "Device" | awk '{print $2}'

    [ -h "/usr/local/sbin/airport" -o -h "/usr/local/bin/airport" ] && return
    echo "[setup] Linking airport"
    sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/local/sbin/airport
}

function call_visudo
{
    export EDITOR=$0 && sudo -E visudo 2>/dev/null
}

LINUX_SUDOERS_EDIT=
## This is why Linux will never be big on personal computers...
# Ubuntu/Debian based distros
if [ -x "/usr/bin/apt-get" ]
then
    LINUX_SUDOERS_EDIT="%sudo ALL=NOPASSWD: /usr/sbin/tcpdump,/sbin/iw,/sbin/ifconfig"
# Arch based distros
elif [ -x "/usr/bin/pacman" ]
then
    LINUX_SUDOERS_EDIT="%sudo ALL=NOPASSWD: /usr/bin/tcpdump,/usr/bin/iw,/usr/bin/ifconfig"
# Not supporting anything else for now...
else
    die "Sorry, your distro is not supported yet."
fi
MACOS_SUDOERS_EDIT="%sudo ALL=NOPASSWD: /usr/local/sbin/airport"

if [ -z "$1" ]
then
    [ `uname` = "Linux" ] && setup_linux
    [ `uname` = "Darwin" ] && setup_macos
    call_visudo && exit
elif [ "$1" = "--skip-install" ]
then
    call_visudo && exit
else
    while [ "$1" != "/etc/sudoers.tmp" ]; do shift; done
    [ `uname` = "Linux" ] && ! fgrep "$LINUX_SUDOERS_EDIT" $1 >/dev/null && echo $LINUX_SUDOERS_EDIT >> $1 && echo "[setup] Editing /etc/sudoers"
    [ `uname` = "Darwin" ] && ! fgrep "$MACOS_SUDOERS_EDIT" $1 >/dev/null && echo $MACOS_SUDOERS_EDIT >> $1 && echo "[setup] Editing /etc/sudoers"
    echo "[setup] Done!"
fi
