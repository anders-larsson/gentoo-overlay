# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 qmake-utils

MY_P="${P/dwarf-therapist/Dwarf-Therapist/}"
DESCRIPTION="Dwarf Fortress extension to manage dwarves"
HOMEPAGE="https://github.com/splintermind/Dwarf-Therapist/"
EGIT_REPO_URI="https://github.com/splintermind/Dwarf-Therapist"
EGIT_BRANCH="DF2014"
EGIT_BOOSTRAP=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="DF2012 +qt4 qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

if use DF2012; then
	EGIT_BRANCH="DF2012"
fi

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
}
# Patch paths to config files. This should be fixed by upstream.
# Issue: https://github.com/splintermind/Dwarf-Therapist/issues/30
src_prepare()
{
	epatch "${FILESDIR}/fix_config_paths.diff"
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
}
