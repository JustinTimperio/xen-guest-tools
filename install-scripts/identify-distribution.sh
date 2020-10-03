#!/usr/bin/env bash

# ======================================
# Offically Supported and Tested Distros
#   Debian Based:
#    - Ubuntu 16-20
#    - Debian 5-10
#    - Kali Rolling
#
#   RHL Based:
#    - Fedora 28-32
#    - Fedora CoreOS
#    - CentOS 6-8
#    - RHEL 6-8
#
#   Suse Based:
#    - Leap 15
#    - TumbleWeed
#    - SELS 10-15
#
#   Arch Based:
#    - Arch Linux
#    - Manjaro
#
#   Alpine Based:
#    - Alpine Linux 3.4-3.13
#
#   BSD Based:
#    - FreeBSD 10-12
# ======================================

print_output(){
  echo "Distro_Name=$name"
  echo "Package_Manager=$pkg_manager"
  echo "Kernel=$kernel"
  echo "Major=$major"
  echo "Minor=$minor" 
  echo "Patch=$patch"
}


identify_pkg_manager(){
  # Deb Based
  if [ -f "/usr/bin/apt" ] || [ -f "/bin/apt" ]; then
    pkg_manager="apt"

  # RHL Based
  elif [ -f "/usr/bin/yum" ] || [ -f "/bin/yum" ]; then
    pkg_manager="yum"

  # SUSE Based
  elif [ -f "/usr/bin/zypper" ]; then
    pkg_manager="zypper"

  # Arch Based
  elif [ -f "/usr/bin/pacman" ] || [ -f "/bin/pacman" ]; then
    pkg_manager="pacman"

  # FreeBSD
  elif [ -f "/usr/sbin/pkg" ]; then
    pkg_manager="pkg"

  # Alpine Linux
  elif [ -f "/sbin/apk" ]; then
    pkg_manager="apk"

  # Can't Determine
  else
    pkg_manager="UNKNOWN"
  fi
}


identify_deb(){
  if [ -f "/etc/os-release" ]; then
    kernel=$(uname -r)
    name=$(cat /etc/os-release | sed 's/"//g' | awk -F '[= ]' '/^NAME=/ { print $2 }')
    
    if $name == "Ubuntu"; then
      # Tested
      major=$(cat /etc/os-release | sed 's/"//g' | awk -F '[=. ]' '/^VERSION=/ { print $2 }')
      minor=$(cat /etc/os-release | sed 's/"//g' | awk -F '[=. ]' '/^VERSION=/ { print $3 }')
      patch=$(cat /etc/os-release | sed 's/"//g' | awk -F '[=. ]' '/^VERSION=/ { print $4 }')
    
    elif $name == "Debian"; then
      # Tested
      major=$(head -1 /etc/debian_version | sed 's/"//g' | awk -F '[=.]' '{ print $1 }')
      minor=$(head -1 /etc/debian_version | sed 's/"//g' | awk -F '[=.]' '{ print $2 }')
      patch=''
    
    elif $name == "Kali"; then
      # Tested
      major=$(cat /etc/os-release | sed 's/"//g' | awk -F '[=.]' '/^VERSION=/ { print $2 }')
      minor=$(cat /etc/os-release | sed 's/"//g' | awk -F '[=.]' '/^VERSION=/ { print $3 }')
      patch=''
    
    else
      # Un-Tested
      major=$(cat /etc/os-release | sed 's/"//g' | awk -F '[=]' '/^VERSION_ID/ { print $2 }')
      minor='UNKNOWN'
      patch='UNKNOWN'
    fi
  
  else
    echo 'System is Based on Debian Linux But NO Release Info Was Found in "/etc/os-release"!'
    exit
  fi
}


identify_rhl(){
  # Un-Tested
  kernel=$(uname -r)
  
  if [ -f "/etc/os-release" ]; then
    name=$(cat /etc/os-release | sed 's/"//g' | awk -F '[= ]' '/^NAME=/ { print $2 }')
  
  elif [ -f "/etc/redhat-release" ]; then
    echo fuck
  
  elif [ -f "/etc/oracle-release" ]; then
    echo fuck
  
  else
    echo 'System is Based on RedHat Linux But NO Release Info Was Found!'
    exit
  fi
}


identify_suse(){
  # Un-Tested
  kernel=$(uname -r)

  if [ -f "/etc/os-release" ]; then
    echo fuck
  
  elif [ -f "/etc/SUSE-release" ]; then
    echo fuck
  
  else
    echo 'System is Based on openSUSE But NO Release Info Was Found!'
    exit
  fi
}


identify_arch(){
  # Tested
  kernel=$(uname -r | awk -F '[-]' '{print $1}')
  if [ -f "/etc/os-release" ]; then
    name=$(cat /etc/os-release | sed -e 's/"//g' | awk -F '=' '/^NAME/ { print $2 }')
    major=$(cat /etc/os-release | sed -e 's/"//g' | awk -F '=' '/^BUILD_ID/ { print $2 }')
    minor=$(cat /etc/os-release | sed -e 's/"//g' | awk -F '=' '/^BUILD_ID/ { print $2 }')
    patch=$(cat /etc/os-release | sed -e 's/"//g' | awk -F '=' '/^BUILD_ID/ { print $2 }')
  
  else
    echo 'System is Based on Arch Linux But NO Release Info Was Found in "/etc/os-release"!'
    exit
  fi

}


identify_freebsd(){
  # Tested
  name=$(uname)
  kernel=$(uname -K)
  major=$(uname -r | awk -F '[.-]' "{print $1}")
  minor=$(uname -r | awk -F '[.-]' "{print $2}")
  patch=$(uname -r | awk -F '[.-]' "{print $4}")
}


identify_alpine(){
  # Tested
  if [ -f "/etc/os-release" ]; then
    kernel=$(uname -r | awk -F '[-]' '{print $1}')
    name=$(cat /etc/os-release | sed 's/"//g' | awk -F '[= ]' '/^NAME=/ { print $2 }')
    major=$(cat /etc/os-release | sed 's/"//g' | awk -F '[=. ]' '/^VERSION_ID=/ { print $2 }')
    minor=$(cat /etc/os-release | sed 's/"//g' | awk -F '[=. ]' '/^VERSION_ID=/ { print $3 }')
    patch=$(cat /etc/os-release | sed 's/"//g' | awk -F '[=. ]' '/^VERSION_ID=/ { print $4 }')
  
  else
    exit 'System is Based Alpine Linux But NO Release Info Was Found in "/etc/os-release"!'
  fi
}


# Use PKG Manager Trigger Identification Process
identify_pkg_manager

if [[ "$pkg_manager" == "apt" ]]; then
  identify_deb
  print_output

elif [[ "$pkg_manager" == "yum" ]]; then
  identify_rhl
  print_output

elif [[ "$pkg_manager" == "zypper" ]]; then
  identify_suse
  print_output

elif [[ "$pkg_manager" == "pkg" ]]; then
  identify_bsd
  print_output

elif [[ "$pkg_manager" == "apk" ]]; then
  identify_apline
  print_output

elif [[ "$pkg_manager" == "pacman" ]]; then
  identify_arch
  print_output

else
  echo 'Could NOT Determine The Systems Package Manager!' 
  exit
fi

