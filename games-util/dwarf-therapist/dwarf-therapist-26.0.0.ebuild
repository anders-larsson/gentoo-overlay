# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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
	if use DF2012; then
		EGIT_BRANCH="DF2012"
	fi
	KEYWORDS=""
else
	SRC_URI="https://github.com/splintermind/${PN}/archive/v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"
IUSE="DF2012 +qt4 qt5 doc"
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
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	doc? (
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	sys-libs/zlib
	dev-libs/openssl
	media-libs/libpng
	dev-libs/libpcre
	x11-libs/libXext
	x11-libs/libxcb"
RDEPEND="${DEPEND}"

pkg_setup()
{
	if ( use DF2012 && use qt4 ) ; then
		eerror
		eerror "dwarf-therapist[DF2012] can only be built with qt5."
		eerror "Building dwarf-therapist with qt4 support will fail (not supported)."
		eerror "Add use flag qt5 instead."
		eerror
	fi

	if ! use doc; then
		einfo
		einfo "Use flag doc is disabled. Dwarf Therapist's pdf manual will not be built."
		einfo "If you want to use the manual you have to download it manual and place it it as /usr/share/dwarftherapist/doc/Therapist Manual.pdf"
		einfo "http://dffd.wimbli.com/file.php?id=7889"
		einfo
	fi
}

src_configure()
{
	if use qt4; then
		eqmake4
	elif use qt5; then
		eqmake5
	fi
}

src_install()
{
	INSTALL_ROOT=${D} emake install
	dodoc ${DOCS[@]}
	if use doc; then
		dodoc "doc/Dwarf Therapist.pdf"
		dodir /usr/share/dwarftherapist/doc/
		dosym "/usr/share/doc/dwarf-therapist-${PV}/Dwarf Therapist.pdf" \
			"/usr/share/doc/dwarftherapist/Dwarf Therapist.pdf"
		dosym "/usr/share/doc/dwarf-therapist-${PV}/Dwarf Therapist.pdf" \
			"/usr/share/dwarftherapist/doc/Therapist Manual.pdf"
	fi
}
