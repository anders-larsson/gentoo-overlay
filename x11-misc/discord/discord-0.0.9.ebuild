# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="All-in-one voice and text chat"

HOMEPAGE="https://discordapp.com/"

SRC_URI="https://dl-canary.discordapp.net/apps/linux/${PV}/discord-canary-${PV}.tar.gz"
RESTRICT="mirror"
KEYWORDS="~amd64"

SLOT="0"
LICENSE="hammer-and-chisel"
RDEPEND=""
DEPEND="${RDEPEND}
	dev-libs/expat
	dev-libs/nss
	gnome-base/gconf
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/libpng
	net-print/cups
	net-libs/gnutls
	sys-libs/zlib
	x11-libs/gtk+
	x11-libs/libnotify
	x11-libs/libxcb
	x11-libs/libXtst
	"

S=${WORKDIR}/DiscordCanary

src_install() {
	local destdir="/opt/${PN}"

	insinto $destdir
	doins -r locales resources
	doins \
		blink_image_resources_200_percent.pak \
		content_resources_200_percent.pak \
		ui_resources_200_percent.pak \
		views_resources_200_percent.pak \
		content_shell.pak \
		discord.png \
		icudtl.dat \
		natives_blob.bin \
		snapshot_blob.bin \
		libnode.so \
		libffmpeg.so

	exeinto $destdir
	doexe DiscordCanary

	dosym $destdir/DiscordCanary /usr/bin/discord
	make_desktop_entry discord Discord \
		"/opt/discord/discord.png" \
		Network
}
