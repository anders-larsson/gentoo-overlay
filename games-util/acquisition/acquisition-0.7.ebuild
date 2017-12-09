# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs qmake-utils

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
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
IUSE="test"

RDEPEND="
	dev-db/sqlite
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	"
DEPEND="${RDEPEND}
	dev-libs/boost
	test? (
		dev-qt/qttest:5
	)
	"

pkg_setup() {
	if [[ $(tc-getCXX) == *g++ && ($(gcc-version) < 4.8) ]]; then
		eerror "dev-lang/gcc-4.8 or newer is required to build acquisition"
		die "Missing c++11 feature"
	fi
}

src_prepare() {
	default
	sed -e "/INCLUDEPATH/ s/deps\/boost-header-only//" -i acquisition.pro || die
	if ! use test; then
		sed -e "/^QT/ s/testlib//" \
			-e "/\W*test\//d" -i acquisition.pro || die
		sed -e "/QCommandLineOption/ s/option_test\S*//" \
			-e "/testmain.h/d" -e "/option_test/d" \
			-e "/test_main/d" -i src/main.cpp || die
	fi
}

src_configure() {
	eqmake5
}

src_install() {
	dobin acquisition
}
