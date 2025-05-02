# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Lightweight Kubernetes (binary package)"
HOMEPAGE="https://k3s.io/
	https://github.com/k3s-io/k3s/"
SRC_URI="https://github.com/k3s-io/k3s/releases/download/v${PV}+k3s1/k3s
	-> ${P}-amd64"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip"

RDEPEND="
	>=app-containers/slirp4netns-1.2.0
	>=app-misc/yq-go-4.44.3
	>=net-firewall/conntrack-tools-1.4.8
"

QA_PREBUILT="*"

src_unpack() {
	cp "${DISTDIR}/${P}-amd64" "${WORKDIR}/k3s" || die
}

src_install() {
	exeinto /usr/bin
	doexe k3s
	newexe "${FILESDIR}/k3s-killall.sh" k3s-killall

	systemd_dounit "${FILESDIR}/k3s.service"
	newinitd "${FILESDIR}/k3s.initd" k3s
	newconfd "${FILESDIR}/k3s.confd" k3s

	insinto /etc/logrotate.d
	newins "${FILESDIR}/k3s.logrotated" k3
}
