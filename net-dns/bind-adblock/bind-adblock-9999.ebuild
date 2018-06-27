# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=(python{3_4,3_5,3_6})

inherit git-r3
inherit python-r1

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
	|| ( dev-python/pycryptodome[${PYTHON_USEDEP}] dev-python/pycrypto[${PYTHON_USEDEP}] )
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

src_install() {
	dobin update-zonefile.py
	dodoc README.md
}
