# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="HTTP client mock for Python"
HOMEPAGE="https://github.com/gabrielfalcao/httpretty"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86"

RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]"
# redis skipped as it requires a redis server running
DEPEND="
	test? (
		>=dev-python/boto3-1.17.72[${PYTHON_USEDEP}]
		dev-python/eventlet[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.18.1[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		>=dev-python/requests-1.1[${PYTHON_USEDEP}]
		dev-python/sure[${PYTHON_USEDEP}]
		>=www-servers/tornado-2.2[${PYTHON_USEDEP}]
)"

distutils_enable_tests nose

python_prepare_all() {
	# remove useless deps
	sed -i -e '/rednose/d' setup.cfg || die
	# tests requiring network access
	rm tests/functional/test_passthrough.py || die

	distutils-r1_python_prepare_all
}
