#!/usr/bin/env sh

basepath=$(dirname $(dirname $(realpath $0)))
scripts_path=$basepath/scripts
release_path=$basepath/scripts/nixinfo/release-info

print_test_results(){
echo "==================== $1 ===================="
echo ''
$scripts_path/identify-distribution.sh $release_path/$2 $release_path/$3 
echo ''
}


# Deb Based
print_test_results 'Debian 10' /debian_10/etc/os-release /debian_10/etc/debian_version
print_test_results 'Debian 9' /debian_9/etc/os-release /debian_9/etc/debian_version
print_test_results 'Ubuntu 20.04' /ubuntu_20.04/etc/os-release
print_test_results 'Ubuntu 18.04' /ubuntu_18.04/etc/os-release
print_test_results 'Ubuntu 16.04' /ubuntu_16.04/etc/os-release
print_test_results 'Kali Linux' /kali/etc/os-release
print_test_results 'ParrotOS' /parrot/etc/os-release

# RHEL Based
print_test_results 'CentOS 8' /centos_8/etc/os-release /centos_8/etc/centos-release
print_test_results 'CentOS 7' /centos_7/etc/os-release /centos_7/etc/centos-release
# print_test_results 'RHEL 8' /parrot/etc/os-release
print_test_results 'RHEL 7' /rhel_7/etc/os-release
print_test_results 'Fedora 32' /fedora_32/etc/os-release
# print_test_results 'Fedora 31' /fedora_31/etc/os-release
# print_test_results 'Fedora 30' /fedora_30/etc/os-release
print_test_results 'Oracle Linux 8' /oracle_linux_8/etc/os-release

# SUSE Based
print_test_results 'Leap 15' /leap_15/etc/os-release
print_test_results 'Tumbleweed' /tumbleweed/etc/os-release
print_test_results 'SLES 15 SP1' /sles_15_sp1/etc/os-release
print_test_results 'SLES 15' /sles_15/etc/os-release
print_test_results 'SLES 12 SP5' /sles_12_sp5/etc/os-release

# Other OS's
print_test_results 'Arch Linux' /arch/etc/os-release
print_test_results 'Alpine Linux 3.12' /alpine_3.12/etc/os-release
