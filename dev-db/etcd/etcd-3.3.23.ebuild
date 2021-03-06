# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module systemd tmpfiles
GIT_COMMIT=4873f5516
MY_PV="${PV/_rc/-rc.}"

DESCRIPTION="Highly-available key value store for shared configuration and service discovery"
HOMEPAGE="https://github.com/etcd-io/etcd"
SRC_URI="https://github.com/etcd-io/etcd/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc +server"

COMMON_DEPEND="server? (
	acct-group/etcd
	acct-user/etcd
	)"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	!dev-db/etcdctl"

# Tests hang and emit this error:
# Too many goroutines running after all test(s).
RESTRICT="test"

src_prepare() {
	export GO_BUILD_FLAGS="-mod=vendor -v -x"
	default
	sed -e "s|GIT_SHA=.*|GIT_SHA=${GIT_COMMIT}|"\
		-i "${S}"/build || die
	sed -e 's:\(for p in \)shellcheck :\1 :' \
		-e 's:^			gofmt \\$:\\:' \
		-e 's:^			govet \\$:\\:' \
		-e 's:^			govet_shadow \\$:\\:' \
		-i "${S}"/test || die
	# missing ... in args forwarded to print-like function
	sed -e 's:l\.Logger\.Panic(v):l.Logger.Panic(v...):' \
		-i "${S}"/raft/logger.go || die

	sed -e 's:TestGetDefaultInterface(:_\0:' \
		-e 's:TestGetDefaultHost(:_\0:' \
		-i "${S}"/pkg/netutil/routes_linux_test.go || die

	rm "${S}"/pkg/tlsutil/cipher_suites_test.go || die

	sed -e "s|GO_BUILD_FLAGS=\"[^\"]*\"|GO_BUILD_FLAGS=\"${GO_BUILD_FLAGS}\"|" \
		-e "s|go test |go test ${GO_BUILD_FLAGS} |" \
		-i ./test || die

	mkdir -p vendor/github.com/coreos || die
	ln -s ../../.. vendor/github.com/coreos/etcd || die
}

src_compile() {
	 ./build || die
}

src_test() {
	./test || die
}

src_install() {
	dobin bin/etcdctl
	use doc && dodoc -r Documentation
	if use server; then
		insinto /etc/${PN}
		doins "${FILESDIR}/${PN}.conf"
		dobin bin/etcd
		dodoc README.md
		systemd_dounit "${FILESDIR}/${PN}.service"
		newtmpfiles "${FILESDIR}/${PN}.tmpfiles.d.conf" ${PN}.conf
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		newconfd "${FILESDIR}"/${PN}.confd ${PN}
		insinto /etc/logrotate.d
		newins "${FILESDIR}/${PN}.logrotated" "${PN}"
		keepdir /var/lib/${PN}
		fowners ${PN}:${PN} /var/lib/${PN}
		fperms 0700 /var/lib/${PN}
		keepdir /var/log/${PN}
		fowners ${PN}:${PN} /var/log/${PN}
		fperms 755 /var/log/${PN}
	fi
}

pkg_postinst() {
	if use server; then
		tmpfiles_process ${PN}.conf
	fi
}
