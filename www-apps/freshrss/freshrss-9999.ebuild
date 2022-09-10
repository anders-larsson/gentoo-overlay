# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit webapp vcs-snapshot

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
fi

DESCRIPTION="FreshRSS - a free, self-hostable aggregator"
HOMEPAGE="https://freshrss.org/"
LICENSE="AGPL-3"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	EGIT_BOOTSTRAP=""
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

IUSE="mysql sqlite postgres +gmp +unicode +iconv +zip +zlib"

# DOM is enabled by flag xml
# XML is enabled by simplexml
# mbstring is enabled by unicode
DEPEND="
	|| (
		<dev-lang/php-8[curl,xml,json,simplexml,session,ctype,pdo,mysql?,sqlite?,postgres?,gmp?,unicode?,iconv?,zip?,zlib?]
		>=dev-lang/php-8[curl,xml,simplexml,session,ctype,pdo,mysql?,sqlite?,postgres?,gmp?,unicode?,iconv?,zip?,zlib?]
	)
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
