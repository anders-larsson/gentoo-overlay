# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} = 9999 ]]; then
	inherit git-2
fi

DESCRIPTION="highly flexible status line for the i3 window manager"
HOMEPAGE="https://github.com/vivien/i3blocks"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/vivien/${PN}"
	EGIT_BOOTSTRAP=""
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI="https://github.com/vivien/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
RDEPEND="x11-wm/i3"
DEPEND="${RDEPEND}
	app-text/ronn
	"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
