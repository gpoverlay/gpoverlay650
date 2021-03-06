# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A Python wrapper for GnuPG"
HOMEPAGE="
	https://bitbucket.org/vinay.sajip/python-gnupg
	https://pypi.org/project/python-gnupg/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
LICENSE="BSD"
SLOT="0"

RDEPEND="app-crypt/gnupg"
DEPEND="${RDEPEND}"

distutils_enable_tests unittest

python_test() {
	# NO_EXTERNAL_TESTS must be enabled,
	# to disable all tests, which need internet access.
	NO_EXTERNAL_TESTS=1 eunittest
}
