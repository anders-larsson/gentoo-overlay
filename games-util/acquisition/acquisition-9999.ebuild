# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs qmake-utils

if [[ ${PV} = 9999 ]]; then
	inherit git-2
fi

DESCRIPTION="Acquisition is an inventory management tool for Path of Exile"
HOMEPAGE="http://github.com/xyzz/${PN}"
LICENSE="GPL-3"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/xyzz/${PN}"
	EGIT_BOOTSTRAP=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/xyzz/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	"
RDEPEND="${DEPEND}"

pkg_setup() {
	if [[ $(tc-getCXX) == *g++ && ($(gcc-version) < 4.8) ]]; then
		eerror "dev-lang/gcc-4.8 or newer is required to build acquisition"
		die "Missing c++11 feature"
	fi
}

src_configure() {
	eqmake5
}

src_install() {
	dobin acquisition
}
