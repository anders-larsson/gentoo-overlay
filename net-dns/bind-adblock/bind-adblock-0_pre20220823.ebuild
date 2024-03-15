# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="Fetch various blocklists and generate a BIND zone from them."
HOMEPAGE="https://github.com/Trellmor/bind-adblock"

MY_COMMIT="85e70560d9804bd92b7d0a4d9833ccc8b7a4c74a"
SRC_URI="https://github.com/Trellmor/bind-adblock/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="network-cron systemd"

RDEPEND="
	dev-python/pycryptodome
	dev-python/dnspython
	dev-python/requests
	dev-python/pyyaml
	dev-python/validators
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
	doexe "${FILESDIR}/bind-adblock.sh"

	insinto /opt/bind-adblock
	doins README.md

	insinto /etc/bind-adblock
	doins blocklist.txt config.yml

	dosym ../bind-adblock/update-zonefile.py /opt/bin/update-zonefile.py
	dosym ../bind-adblock/bind-adblock.sh /opt/bin/bind-adblock.sh

	if use network-cron; then
		dosym ../../opt/bin/bind-adblock.sh /etc/cron.daily/bind-adblock.sh
	fi

	if use systemd; then
		systemd_dounit "${FILESDIR}"/bind-adblock.{service,timer}
	fi
}
