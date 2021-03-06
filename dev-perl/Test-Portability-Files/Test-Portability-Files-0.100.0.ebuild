# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ABRAXXA
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="Check file names portability"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-File-Temp-0.230.400
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.980.0
	)
"

src_prepare() {
	perl_rm_files t/release-*.t t/author-*.t
	perl-module_src_prepare
}
