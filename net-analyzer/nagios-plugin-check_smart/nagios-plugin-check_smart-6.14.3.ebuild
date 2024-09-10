# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module vcs-snapshot

MY_PN="${PN/nagios-plugin-/}"

DESCRIPTION="Nagios plugin to monitor SMART health values for disks"
HOMEPAGE="https://github.com/Napsty/check_smart"
SRC_URI="https://github.com/Napsty/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Getopt-Long
	sys-apps/smartmontools
"

src_install() {
	local plugindir="/usr/$(get_libdir)/nagios/plugins"
	exeinto "${plugindir}"
	newexe check_smart.pl check_smart
}
