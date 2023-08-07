# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Duo two-factor authentication for Unix systems"
HOMEPAGE="https://www.duosecurity.com"
SRC_URI="https://dl.duosecurity.com/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pam"

DEPEND="dev-libs/openssl
	sys-libs/zlib
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_with pam)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc README.md
}
