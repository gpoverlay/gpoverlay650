# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MUIR
DIST_SECTION=modules
DIST_VERSION=2015.103
inherit perl-module

DESCRIPTION="A Date/Time Parsing Perl Module"

LICENSE="Time-modules public-domain"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND=""
DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Time-Piece )
"
