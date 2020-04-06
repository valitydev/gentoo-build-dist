# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.6.3
ansi_term-0.10.2
atty-0.2.6
autocfg-0.1.6
backtrace-0.3.3
backtrace-sys-0.1.16
bitflags-1.0.1
bit-set-0.5.0
bit-vec-0.5.0
byteorder-1.2.7
cc-1.0.3
cfg-if-0.1.2
chrono-0.4.5
clap-2.29.0
cloudabi-0.0.3
crc-1.4.0
dbghelp-sys-0.2.0
dbus-0.6.4
devicemapper-0.28.0
dtoa-0.4.1
either-1.1.0
env_logger-0.5.10
errno-0.2.3
error-chain-0.12.1
fnv-1.0.6
fuchsia-cprng-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
humantime-1.1.1
itertools-0.8.0
itoa-0.3.1
kernel32-sys-0.2.2
lazy_static-0.2.8
lazy_static-1.4.0
libc-0.2.55
libdbus-sys-0.1.5
libmount-0.1.13
libudev-0.2.0
libudev-sys-0.1.3
log-0.4.2
loopdev-0.2.0
matches-0.1.8
memchr-1.0.1
memchr-2.0.1
nix-0.14.0
num-integer-0.1.39
num-traits-0.1.37
num-traits-0.2.5
pkg-config-0.3.9
proptest-0.9.4
quick-error-1.2.2
quote-0.3.15
rand-0.4.3
rand-0.5.5
rand-0.6.5
rand_chacha-0.1.1
rand_core-0.2.2
rand_core-0.3.1
rand_core-0.4.2
rand_hc-0.1.0
rand_isaac-0.1.1
rand_jitter-0.1.4
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
rdrand-0.4.0
redox_syscall-0.1.18
redox_termios-0.1.1
regex-1.0.1
regex-syntax-0.6.1
remove_dir_all-0.5.1
rustc-demangle-0.1.5
rusty-fork-0.2.1
serde-1.0.82
serde_derive-1.0.8
serde_derive_internals-0.15.1
serde_json-1.0.2
strsim-0.6.0
syn-0.11.11
synom-0.11.3
tempfile-3.0.2
termcolor-0.3.6
termion-1.5.1
textwrap-0.9.0
thread_local-0.3.4
time-0.1.37
timerfd-1.0.0
ucd-util-0.1.1
unicode-width-0.1.4
unicode-xid-0.0.4
unreachable-1.0.0
utf8-ranges-1.0.0
uuid-0.7.1
vec_map-0.8.0
version_check-0.1.5
void-1.0.2
wait-timeout-0.1.5
winapi-0.2.8
winapi-0.3.3
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.3.2
winapi-x86_64-pc-windows-gnu-0.3.2
wincolor-0.1.6
"

inherit cargo systemd

DESCRIPTION="Linux local storage management tool that aims to enable easy use of advanced storage features such as thin provisioning, snapshots, and pool-based management and monitoring."
HOMEPAGE="https://stratis-storage.github.io/"
SRC_URI="https://github.com/stratis-storage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris ${CRATES})"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	>=virtual/rust-1.37.0
"
DEPEND="
	sys-apps/dbus
	|| ( sys-fs/eudev sys-fs/udev )
	dev-libs/libpcre
"
RDEPEND="
	${DEPEND}
	sys-fs/xfsprogs
	sys-block/thin-provisioning-tools
"

QA_FLAGS_IGNORED="/sbin/stratisd /usr/libexec/stratisd"

src_compile(){
	cargo_src_compile --no-default-features
	mv "${S}"/target/release/stratisd "${S}"/target/release/stratisd-init
	cargo_src_compile --all-features
}

src_install() {
	exeinto /sbin
	doexe	"${S}"/target/release/stratisd-init

	exeinto /usr/libexec
	doexe "${S}"/target/release/stratisd

	einstalldocs
	dodoc -r docs/.

	newinitd "${FILESDIR}/init.d.stratisd-r1" stratisd
	systemd_dounit "${S}/stratisd.service"

	insinto /etc/dbus-1/system.d
	doins ${S}/stratisd.conf
}
