# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..14} )

inherit distutils-r1

MY_PN="${PN/nagios-plugin-/}"

DESCRIPTION="check_systemd is a Nagios / Icinga monitoring plugin to check systemd"
HOMEPAGE="https://github.com/Josef-Friedrich/check_systemd"
SRC_URI="https://github.com/Josef-Friedrich/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/nagiosplugin"

src_install() {
	local plugindir="/usr/$(get_libdir)/nagios/plugins"
	exeinto "${plugindir}"
	newexe check_systemd.py check_systemd
}
