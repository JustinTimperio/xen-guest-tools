#!/usr/bin/env sh

# ======================================
# Offically Supported and Tested Distros
#   Debian Based:
#    - Ubuntu 16-20
#    - Debian 9-10
#    - Kali Rolling
#    - Parrot OS
#
#   RHL Based:
#    - Fedora 28-32
#    - CentOS 7-8
#    - RHEL 7-8
#    - Oracle Linux
#
#   Suse Based:
#    - Leap 15
#    - TumbleWeed
#    - SLES 12-15
#
#   Arch Based:
#    - Arch Linux
#
#   Alpine Based:
#    - Alpine Linux 3.4-3.13
#
#   BSD Based:
#    - FreeBSD 11-12
# ======================================


if [ "$(uname)" = "FreeBSD" ]; then
  kernel=$(uname -r)
  distro=$(uname)
  name="$(uname) $(uname -r)"
  major=$(uname -r | awk -F '[.-]' '{ print $1 }')
  minor=$(uname -r | awk -F '[.-]' '{ print $2 }')
  patch='n/a'

elif [ "$(uname)" = "Linux" ]; then
  distro=$(awk -F'[= ]' '/^NAME=/{ gsub(/"/,""); print tolower($2)}' /etc/os-release)
  kernel=$(uname -r)

  case $distro in
    "arch")
      name=$(awk -F '=' '/^NAME/ { gsub(/"/,""); print $2 }' /etc/os-release)
      major=$(awk -F '=' '/^BUILD_ID/ { gsub(/"/,""); print $2 }' /etc/os-release)
      minor=$(awk -F '=' '/^BUILD_ID/ { gsub(/"/,""); print $2 }' /etc/os-release)
      patch=$(awk -F '=' '/^BUILD_ID/ {  gsub(/"/,""); print $2 }' /etc/os-release)
      ;;

    "parrot")
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      major=$(awk -F '[=. ]' '/^VERSION=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      minor=$(awk -F '[=. ]' '/^VERSION=/ { gsub(/"/,"");  print $3 }' /etc/os-release)
      patch='n/a'
      ;;

    "ubuntu")
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      major=$(awk -F '[=. ]' '/^VERSION=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      minor=$(awk -F '[=. ]' '/^VERSION=/ { gsub(/"/,"");  print $3 }' /etc/os-release)
      patch=$(awk -F '[=. ]' '/^VERSION=/ { gsub(/"/,"");  print $4 }' /etc/os-release)
      ;;

    "debian")
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      major=$(head -1 /etc/debian_version | awk -F '[=.]' '{ gsub(/"/,""); print $1 }')
      minor=$(head -1 /etc/debian_version | awk -F '[=.]' '{ gsub(/"/,""); print $2 }')
      patch='n/a'
      ;;

    "kali")
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      major=$(awk -F '[=.]' '/^VERSION=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      minor=$(awk -F '[=.]' '/^VERSION=/ { gsub(/"/,"");  print $3 }' /etc/os-release)
      patch='n/a'
      ;;

    "alpine")
      name=$(awk -F '=' '/^PRETTY_NAME=/{ print $2 }' /etc/os-release)
      major=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      minor=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' /etc/os-release)
      patch='n/a'
      ;;

    "sles")
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      major=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      minor=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' /etc/os-release)
      patch='n/a'
      ;;

    "fedora")
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      major=$(awk -F '[= ]' '/^VERSION=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      minor='n/a'
      patch='n/a'
      ;;
  
    "centos")
      name=$(cat /etc/centos-release)
      major=$(grep -o '[0-9]\+' /etc/centos-release | sed -n '1p')
      minor=$(grep -o '[0-9]\+' /etc/centos-release | sed -n '2p')
      patch=$(grep -o '[0-9]\+' /etc/centos-release | sed -n '3p')
      ;;

    "oracle")
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      major=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      minor=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' /etc/os-release)
      patch='n/a'
      ;;
  
    "redhat")
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
      major='n/a'
      minor='n/a'
      patch='n/a'
      ;;

    "opensuse")
      distro=$(awk -F '[= ]' '/^NAME=/ { gsub(/"/,"");  print tolower($3) }' /etc/os-release)
      case $distro in
        "leap")
          name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
          major=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
          minor=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' /etc/os-release)
          patch='n/a'
          distro='opensuse'
          ;;

        "tumbleweed")
          name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' /etc/os-release)
          major=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' /etc/os-release | rev | cut -c5- | rev)
          minor=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' /etc/os-release | cut -c5- | rev | cut -c3- | rev)
          patch=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' /etc/os-release | cut -c7-)
          distro='opensuse'
          ;;
      esac
      ;;
  esac
fi

# Print Info
if [ -n $os_distro ] && [ -n $major ] && [ -n $kernel ] && [ -n $os_name ]; then
  echo "os_distro=$distro"
  echo "os_name=$name"
  echo "os_uname=$kernel"
  echo "os_majorver=$major"
  echo "os_minorver=$minor"
  echo "os_patch=$patch"
  exit 0

else
  echo 'Could NOT Identify Enough System Infomation!'
  exit 1
fi
