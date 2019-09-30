# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils webapp vcs-snapshot

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
fi

DESCRIPTION="FreshRSS - a free, self-hostable aggregator"
HOMEPAGE="https://freshrss.org/"
LICENSE="AGPL-3"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	EGIT_BOOTSTRAP=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PV}"
fi

IUSE="mysql postgres sqlite"

DEPEND="
	dev-lang/php:*[curl,xml,pdo,gmp,json,iconv,zip,mysql?,postgres?,sqlite?]
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
