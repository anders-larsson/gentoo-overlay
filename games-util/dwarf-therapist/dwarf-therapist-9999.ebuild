# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils

if [[ ${PV} = 9999 ]]; then
	inherit git-2
fi

DESCRIPTION="Dwarf Fortress extension to manage dwarves"
HOMEPAGE="http://github.com/splintermind/${PN}"
LICENSE="MIT"
MY_P="${P/dwarf-therapist/Dwarf-Therapist}"
S="${WORKDIR}/${MY_P}"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/splintermind/${PN}"
	EGIT_BOOTSTRAP=""
	EGIT_BRANCH="DF2014"
	KEYWORDS=""
else
	SRC_URI="https://github.com/splintermind/${PN}/archive/v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"
IUSE="+qt4 qt5 doc"
REQUIRED_USE="^^ ( qt4 qt5 )"
DOCS=( README.rst LICENSE.txt CHANGELOG.txt )

DEPEND="
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtscript:4
		dev-qt/qtdeclarative:4
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	doc? (
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	sys-libs/zlib
	dev-libs/openssl:0
	media-libs/libpng:0
	dev-libs/libpcre
	x11-libs/libXext
	x11-libs/libxcb"
RDEPEND="${DEPEND}"

pkg_setup()
{
	if ! use doc; then
		einfo
		einfo "Use flag doc not set. Manual will not be built."
		einfo "Download it and save it as /usr/share/dwarftherapist/Therapist Manual.pdf if you want it."
		einfo "http://dffd.wimbli.com/file.php?id=7889 (might be outdated)"
		einfo
	fi
}

src_configure()
{
	# Set prefix to /usr. Defaults is /usr/local
	myconf=(
		PREFIX=/usr
	)
	if use qt4; then
		eqmake4 ${myconf[@]}
		# Build only works if it's configured with debug_and_release
		# eqmake4 changes debug_and_release to release. Workaround follows.
		# https://github.com/anders-larsson/gentoo-overlay/issues/12
		sed -i 's/CONFIG += release/CONFIG += debug_and_release/' \
			dwarftherapist.pro
	elif use qt5; then
		eqmake5 ${myconf[@]}
	fi
}

src_install()
{
	INSTALL_ROOT=${D} emake install
	dodoc ${DOCS[@]}
	if use doc; then
		dodoc "doc/Dwarf Therapist.pdf"
		dosym "/usr/share/doc/dwarf-therapist-${PV}/Dwarf Therapist.pdf" \
			"/usr/share/dwarftherapist/Dwarf Therapist.pdf"
	fi
}
