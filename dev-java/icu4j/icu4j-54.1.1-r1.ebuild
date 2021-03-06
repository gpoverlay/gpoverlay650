# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# testdata.jar, icudata.jar and icutzdata.jar do not contain *.class files
# but *.res files. These *.res data files are needed to build the final jar.

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A set of Java libraries providing Unicode and Globalization support"
HOMEPAGE="http://www.icu-project.org/"
SRC_URI="http://download.icu-project.org/files/${PN}/${PV}/${PN}-${PV//./_}.tgz"

LICENSE="icu"
SLOT="52"
KEYWORDS="amd64 ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

# the build system does not support java > 1.8
# also the package does not compile with newer jdks because of missing classes
DEPEND="virtual/jdk:1.8"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}"

HTML_DOCS="readme.html"

JAVA_PKG_BSFIX_NAME+=" common-targets.xml"

EANT_DOC_TARGET="docs"
EANT_TEST_TARGET="check"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dojar ${PN}-charset.jar
	java-pkg_dojar ${PN}-localespi.jar

	einstalldocs

	use doc && java-pkg_dojavadoc doc
	use examples && java-pkg_doexamples demos samples
	use source && java-pkg_dosrc main/classes/*/src/com
}
