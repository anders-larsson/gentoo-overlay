# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Fetch various blocklists and generate a BIND zone from them."
HOMEPAGE="https://github.com/Trellmor/bind-adblock"

EGIT_REPO_URI="https://github.com/Trellmor/bind-adblock.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	dev-python/pycryptodome
	dev-python/dnspython
	dev-python/requests
	dev-python/pyyaml
"

src_install() {
	# Update script to load config file from /etc/bind-adblock for config protection
	sed -i -e "s@main_conf_file =.*@main_conf_file = '/etc/bind-adblock/config.yml'@" \
		update-zonefile.py
	# Update config.yml to include blocklist.txt from /etc/bind-adblock for
	# config protection
	sed -i -e 's@blocklist\.txt@/etc/bind-adblock/blocklist.txt@' \
		config.yml

	exeinto /opt/bind-adblock
	doexe update-zonefile.py

	insinto /opt/bind-adblock
	doins README.md

	insinto /etc/bind-adblock
	doins blocklist.txt config.yml

	dodir /opt/bin
	dosym ../bind-adblock/update-zonefile.py /opt/bin/update-zonefile.py
}

pkg_postinst() {
	echo
	ewarn "Configuration files (config.yml and blocklist.txt) moved to /etc/bind-adblock"
	ewarn "Please update your cron job accordingly."
	echo
}
