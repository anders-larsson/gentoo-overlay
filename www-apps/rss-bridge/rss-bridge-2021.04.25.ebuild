# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils webapp vcs-snapshot

MY_PV="$(ver_rs 1- -)"

if [[ ${MY_PV} = 9999 ]]; then
	inherit git-r3
fi

DESCRIPTION="The RSS feed for websites missing it "
HOMEPAGE="https://github.com/RSS-Bridge/rss-bridge"
LICENSE="Unlicense"

if [[ ${MY_PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/RSS-bridge/${PN}.git"
	EGIT_BOOTSTRAP=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/RSS-bridge/${PN}/archive/${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PV}"
fi

IUSE="sqlite"

DEPEND="
	dev-lang/php:*[ssl,xml,unicode,simplexml,curl,json,filter,sqlite?]
	virtual/httpd-php:*
"

RDEPEND="${DEPEND}"

need_httpd_cgi  # From webapp.eclass

src_install() {
	webapp_src_preinst

	insinto "/${MY_HTDOCSDIR}"
	doins -r *

	webapp_serverowned -R "${MY_HTDOCSDIR}/data"
	webapp_src_install
}

pkg_postinst() {
	elog "See documentation for installation instructions"
	elog "https://github.com/rss-bridge/rss-bridge/wiki/For-hosts"
	elog "Make cache dir read- and writeable by the PHP user running rss-bridge."
}
