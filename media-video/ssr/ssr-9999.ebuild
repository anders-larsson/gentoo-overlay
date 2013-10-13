# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools multilib-minimal

if [[ ${PV} = 9999 ]]; then
	inherit git-2
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
IUSE="mp3 theora vorbis vpx x264"

RDEPEND="
	dev-qt/qtgui
	media-sound/pulseaudio
	virtual/ffmpeg
	virtual/glu
	abi_x86_32? ( app-emulation/emul-linux-x86-opengl )
	mp3? ( virtual/ffmpeg[mp3] )
	theora? ( virtual/ffmpeg[theora] )
	vorbis? ( || ( media-video/ffmpeg[vorbis] media-video/libav[vorbis] ) )
	vpx? ( || ( media-video/ffmpeg[vpx] media-video/libav[vpx] ) )
	x264? ( virtual/ffmpeg[x264] )
	"
DEPEND="${RDEPEND}"

pkg_setup() {
	if [[ ${PV} == "9999" ]]; then
		elog
		elog "This ebuild merges the latest revision available from upstream's"
		elog "git repository, and might fail to compile or work properly once"
		elog "merged."
		elog
	fi

	if [[ ${ABI} == amd64 ]]; then
		elog "You may want to add abi_x86_32 to your use flags if you're using a"
		elog "64bit system. This is neccessary if you want to record 32bit"
		elog "applications using opengl injection"
		elog "To build these add 'media-video/ssr abi_x86' to package.use"
		elog
	fi
}

multilib_src_configure() {
	ECONF_SOURCE=${S}
	if $(is_final_abi ${abi}); then
		econf \
			--enable-dependency-tracking
	else
		econf \
			--enable-dependency-tracking \
			--disable-ssrprogram
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
