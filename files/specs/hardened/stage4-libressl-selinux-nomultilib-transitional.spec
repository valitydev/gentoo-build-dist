subarch: amd64
target: stage4
version_stamp: {{ stage3_stamp }}
rel_type: hardened-glibc-libressl-selinux-transitional
profile: default/linux/amd64/17.1/no-multilib/hardened/selinux
snapshot: {{ snapshot_stamp }}
compression_mode: pixz_x
decompressor_search_order: tar pixz xz lbzip2 bzip2 gzip
source_subpath: hardened/{{ stage3 }}
portage_confdir: /var/tmp/catalyst/salt/portage/stages/libressl_migration
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
	-static-libs
	-static
	system-llvm
	keyring
	portage
	modern-top
	-perl

stage4/packages:
	sys-apps/iproute2
	app-eselect/eselect-repository
	app-portage/gentoolkit
	app-portage/portage-utils
	app-portage/eix
	dev-vcs/git

stage4/fsscript: /var/tmp/catalyst/salt/scripts/libressl-migration.sh

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
