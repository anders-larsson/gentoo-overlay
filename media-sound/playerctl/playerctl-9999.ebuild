# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

if [[ ${PV} = 9999 ]]; then
	inherit git-2
fi

DESCRIPTION="Command-line utility to control media players using MPRIS"
HOMEPAGE="https://github.com/acrisci/playerctl"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/acrisci/${PN}"
	EGIT_BOOTSTRAP=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/acrisci/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"
LICENSE="LGPL-3"
RDEPEND=""
DEPEND="${RDEPEND}
	dev-libs/glib
	dev-util/gtk-doc
	"

src_prepare() {
	gtkdocize || die
	eautoreconf
}

src_compile() {
	# Build fails on anything higher than -j1
	emake -j1
}
