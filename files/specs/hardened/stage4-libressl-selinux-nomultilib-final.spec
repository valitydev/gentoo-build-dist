subarch: amd64
target: stage4
version_stamp: {{ stage3_stamp }}
rel_type: hardened
profile: default/linux/amd64/17.1/no-multilib/hardened/selinux
snapshot: {{ snapshot_stamp }}
compression_mode: pixz_x
decompressor_search_order: tar pixz xz lbzip2 bzip2 gzip
source_subpath: hardened-glibc-libressl-selinux-transitional/stage4-amd64-{{ stage3_stamp }}
portage_confdir: /var/tmp/catalyst/salt/portage/stages/glibc_libressl
portage_overlay: /var/tmp/catalyst/salt/overlay

stage4/use:
	argon2
	audit
	caps
	cgroups
	cracklib
	ecdsa
	efi
	filecaps
	json
	gnupg
	iproute2
	leaps_timezone
	logrotate
	lz4
	lzma
	lzo
	netlink
	nettle
	numa
	seccomp
	smp
	threads
	udev
	xattr
	xfs
	-X
	-tcpd
	-bindist
	bzip2
	idm
	ipv6
	urandom
	http2
	-openssl
	libressl
	curl_ssl_libressl
	-curl_ssl_openssl
	-static-libs
	-static
	-python_targets_python2_7
	system-llvm
	keyring
	portage
	modern-top

stage4/packages:
	net-misc/dhcp
	net-misc/iputils
	sys-boot/grub
	sys-apps/gptfdisk
	sys-apps/iproute2
	sys-devel/bc
	sys-power/acpid
	app-crypt/gentoo-keys
	app-admin/salt
	sys-fs/stratis-cli
	sys-fs/stratisd
	app-editors/vim
	x11-terms/kitty-terminfo
	sys-fs/lvm2

stage4/rcadd:
	acpid|default
	net.lo|default
	netmount|default
	sshd|default
        dbus|default
        stratisd|default

boot/kernel: gentoo
boot/kernel/gentoo/sources: gentoo-sources
boot/kernel/gentoo/config: /var/tmp/catalyst/salt/kconfig/cloud-amd64-hardened.config
boot/kernel/gentoo/gk_kernargs: --all-ramdisk-modules

# all of the cleanup...
stage4/unmerge:
	sys-devel/bc
	sys-kernel/genkernel
	sys-kernel/gentoo-sources

stage4/empty:
	/root/.ccache
	/tmp
	/usr/portage/distfiles
	/usr/src
	/var/cache/edb/dep
	/var/cache/genkernel
	/var/cache/portage/distfiles
	/var/empty
	/var/run
	/var/state
	/var/tmp

stage4/rm:
	/var/db/repos/*
	/etc/*-
	/etc/*.old
	/etc/ssh/ssh_host_*
	/root/.*history
	/root/.lesshst
	/root/.ssh/known_hosts
	/root/.viminfo
	# Remove any generated stuff by genkernel
	/usr/share/genkernel
	# This is 3MB of crap for each copy
	/usr/lib64/python*/site-packages/gentoolkit/test/eclean/testdistfiles.tar.gz
