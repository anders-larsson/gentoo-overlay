# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tiny daemon that listens and sends desktop notifications using the user bus"
HOMEPAGE="https://github.com/rfjakob/systembus-notify"
SRC_URI="https://github.com/rfjakob/systembus-notify/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-apps/systemd"
RDEPEND="${DEPEND}"

src_install() {
	dobin systembus-notify

	insinto /usr/share/applications
	doins systembus-notify.desktop

	dodoc README.md
}
