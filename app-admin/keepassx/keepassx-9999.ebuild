# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="Qt password manager compatible with its Win32 and Pocket PC versions"
HOMEPAGE="http://keepassx.sourceforge.net/"
EGIT_REPO_URI=(
	"git://keepassx.org/${PN}.git"
	"https://github.com/${PN}/${PN}"
)

LICENSE="LGPL-2.1 GPL-2 GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug test +qt4 qt5"

if use qt5; then
	EGIT_BRANCH="qt5"
fi

RDEPEND="dev-libs/libgcrypt:=
	qt4? (
		dev-qt/qtcore:4[qt3support]
		dev-qt/qtgui:4[qt3support]
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtconcurrent:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/linguist-tools:5
	)
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	test? (
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)
"

src_prepare() {
	 use test || \
		if use qt4; then
			sed -e "/^set(QT_REQUIRED_MODULES/s/QtTest//" -i CMakeLists.txt || die
		elif use qt5; then
			sed -e "/^find_package(Qt5Test/d" -i CMakeLists.txt || die
		fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with test TESTS)
		-DWITH_GUI_TESTS=OFF
	)
	cmake-utils_src_configure
}
