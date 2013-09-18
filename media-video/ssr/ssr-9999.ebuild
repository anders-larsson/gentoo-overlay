# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
if [[ ${PV} = 9999 ]]; then
	inherit autotools git-2
fi

DESCRIPTION="A Simple Screen Recorder"
HOMEPAGE="http://www.maartenbaert.be/simplescreenrecorder"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://github.com/MaartenBaert/${PN}.git
		https://github.com/MaartenBaert/${PN}.git"
	EGIT_BOOTSTRAP="eautoreconf"
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI="https://github.com/MaartenBaert/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="x264 vpx theora mp3 vorbis"

RDEPEND=">=dev-qt/qtgui-4.8.4-r1
	x264? ( || ( media-video/ffmpeg media-video/libav ) )
	theora? ( || ( media-video/ffmpeg media-video/libav ) )
	vpx? ( || ( media-video/ffmpeg media-video/libav ) )
	mp3? ( || ( media-video/ffmpeg media-video/libav ) )
	vorbis? ( || ( media-video/ffmpeg media-video/libav ) )"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--enable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
