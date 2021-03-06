# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2

DESCRIPTION="Gnome keyboard configuration library"
HOMEPAGE="https://www.gnome.org"

LICENSE="LGPL-2+"
SLOT="0/8"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.91.7:3[X,introspection?]
	>=x11-libs/libxklavier-5.2[introspection?]

	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable test tests)
}
