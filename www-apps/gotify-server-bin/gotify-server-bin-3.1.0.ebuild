# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Simple server for sending and receiving messages in real-time per WebSocket"
HOMEPAGE="https://gotify.net/"
# NOTE: Only arm64 is tested.
SRC_URI="
	amd64? ( https://github.com/gotify/server/releases/download/v${PV}/gotify-linux-amd64.zip -> ${P}_amd64.zip )
	x86? ( https://github.com/gotify/server/releases/download/v${PV}/gotify-linux-386.zip -> ${P}_x86.zip )
	arm? ( https://github.com/gotify/server/releases/download/v${PV}/gotify-linux-arm-7.zip -> ${P}_arm.zip )
	arm64? ( https://github.com/gotify/server/releases/download/v${PV}/gotify-linux-arm64.zip -> ${P}_arm64.zip )
	riscv? ( https://github.com/gotify/server/releases/download/v${PV}/gotify-linux-riscv64.zip -> ${P}_riscv.zip )
"
S="${WORKDIR}"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="logrotate systemd"

RDEPEND="acct-user/gotify"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

QA_PREBUILT="/usr/bin/${PN}"

src_prepare() {
	cp "${FILESDIR}/${PN}.logrotate" . || die
	if use systemd; then
		sed -Ei "s/^(\s*)rc-service.*/\1systemctl restart ${PN}.service/" \
			${PN}.logrotate || die
	fi

	default
}

src_install() {
	local myarch="amd64"
	use x86 && myarch="368"
	use arm && myarch="arm-7"
	use arm64 && myarch="arm64"
	use riscv && myarch="riscv64"

	newbin gotify-linux-${myarch} ${PN}

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	systemd_newunit "${FILESDIR}/${PN}.service" ${PN}.service

	if use logrotate; then
		insinto etc/logrotate.d
		newins ${PN}.logrotate ${PN}
	fi

	diropts --owner=gotify --group=gotify --mode=750
	keepdir var/lib/gotify
	keepdir etc/gotify
	keepdir var/log/${PN}
}

pkg_postinst() {
	ewarn "Gotify 3.0.0 no longer uses a configuration file for configuration."
	ewarn "See release notes for more information."
	ewarn "https://github.com/gotify/server/releases/tag/v3.0.0"
}
