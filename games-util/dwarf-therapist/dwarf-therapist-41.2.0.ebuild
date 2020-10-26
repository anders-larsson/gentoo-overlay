# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
fi

DESCRIPTION="Dwarf Fortress extension to manage dwarves"
HOMEPAGE="https://github.com/${PN}/${PN}"
LICENSE="MIT"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
	EGIT_BOOTSTRAP=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"

	MY_P="${P/dwarf-therapist/Dwarf-Therapist}"
	S="${WORKDIR}/${MY_P}"
fi

SLOT="0"
IUSE="doc"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	doc? (
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		media-gfx/imagemagick
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
		einfo "Download it and save it as /usr/share/dwarftherapist/Dwarf Therapist.pdf if you want it."
		einfo "http://dffd.wimbli.com/file.php?id=7889 (rarely updated)"
		einfo
	fi
}

src_configure()
{
	local mycmakeargs=()
	if use doc; then
		mycmakeargs+=( -DBUILD_MANUAL=ON )
	fi

	cmake-utils_src_configure
}
