[Chat with us on Gitter](https://gitter.im/xen-guest-tools/Development#)


## Go-Source


General
- [x] What does [guestmetric_test.go](https://github.com/JustinTimperio/xen-guest-tools/blob/master/go-source/guestmetric/guestmetric_test.go) and [xenstore_test.go](https://github.com/JustinTimperio/xen-guest-tools/tree/master/go-source/xenstoreclient) test? Can they be move to `/tests` and used in a release test suite?
    - xenstore_test.go: Seems to be client side testing of xenstore and file perms. No reason to merge with tests 
    - guestmetric_test.go: Seems to be client side testing/benchmarking of vm "hardware" speed. No reason to merge with tests 
- [ ] Can the source files be restructured so there are NOT multiple files with the same name?
- [ ] Can the source files be merged into a single core `/go-source` folder?
- [x] Does the FreeBSD and Alpine forks use different/modified source code?
    - The source code itself does not seem to be modified but it does require non-systemd init scripts. FreeBSD must also be compiled using GOOS=FreeBSD
- [ ] Add case exceptions for issues reported by gosec [here](https://github.com/JustinTimperio/xen-guest-tools/issues/1).

Code Spesific
- [ ] Why is the `unsafe` package called in [system.go](https://github.com/JustinTimperio/xen-guest-tools/blob/master/go-source/system/system.go) and can it be reimplemented in a better way?
- [ ] [Line 53-54 system.go](https://github.com/JustinTimperio/xen-guest-tools/blob/2b300955c23bdd6752c442eecffc8e66665bc7ad/go-source/system/system.go#L53) Getting Error: 'warning| syscall.Timespec composite literal uses unkeyed fields'
- [ ] [Line 64 syslog.go](https://github.com/JustinTimperio/xen-guest-tools/blob/2b300955c23bdd6752c442eecffc8e66665bc7ad/go-source/syslog/syslog.go#L64) Getting Error: 'warning| unreachable code'

## Sysfs
- [ ] Finish modifing `xen-guest-tools.init`
- [ ] Finish modifing `xen-guest-tools.service`
- [ ] Attempt to standardize file locations across distros

## Build Process
- [ ] Finish and test `makefile`
- [ ] Create automated Go source code tests
- [x] Create automated security check
- [ ] Add `pacman` package build process
- [ ] Add `deb` package build process
- [ ] Add `rpm` package build process
- [ ] Add `pkg` package build process
- [ ] Add `apk` package build process

## Install Scripts
- [x] Create automated test for `identify-distribution.sh`
- [ ] Rewrite `iso-install.sh`
- [ ] Write `net-install.sh`

## Manually Test Guest Tools

- [ ] Test Ubuntu 16.04
- [ ] Test Ubuntu 18.04
- [ ] Test Ubuntu 20.04
- [ ] Test Debian 9
- [ ] Test Debian 10
- [ ] Test Kali Linux
- [ ] Test ParrotOS
- [ ] Test RHEL 7
- [ ] Test RHEL 8
- [ ] Test CentOS 7
- [ ] Test CentOS 8
- [ ] Test Fedora 30
- [ ] Test Fedora 31
- [ ] Test Fedora 32
- [ ] Test Oracle Linux 8
- [ ] Test OpenSUSE Leap 15
- [ ] Test OpenSUSE TumbleWeed
- [ ] Test SLES 12
- [ ] Test SLES 15
- [ ] Test Arch Linux 
- [ ] Test Alpine Linux 3.10
- [ ] Test Alpine Linux 3.11
- [ ] Test Alpine Linux 3.12
- [ ] Test Alpine Linux 3.13
- [ ] Test FreeBSD 11
- [ ] Test FreeBSD 12
