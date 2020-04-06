# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="CLI for the Stratis project"
HOMEPAGE="https://stratis-storage.github.io"
SRC_URI="https://github.com/stratis-storage/${PN}/archive/v${PV}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/dbus-python
	dev-python/psutil
	dev-python/python-dateutil
	dev-python/justbytes
	dev-python/dbus-client-gen
	dev-python/dbus-python-client-gen"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest
