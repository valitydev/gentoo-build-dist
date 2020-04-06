# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="transforms values into properly wrapped dbus-python objects"
HOMEPAGE="https://github.com/mulkieran/dbus-python-client-gen https://pypi.org/project/dbus-python-client-gen/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/into-dbus-python"
DEPEND="${RDEPEND}
		dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
