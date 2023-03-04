# Copyright 1999-2023 Gentoo Authors
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

	# freshrss 1.21.0 and newer checks if it can write to index.html in several
	# directories. Every time webapp-config runs it reinstalls these files with
	# the webserver user as their owner. RSS feed refresh script fails to run
	# if PHP user cannot write to the required files causing the refresh to fail.
	# Introduced by https://github.com/FreshRSS/FreshRSS/pull/4780.
	for file in \
			data/index.html \
			data/cache/index.html \
			data/users/index.html \
			data/favicons/index.html \
			data/tokens/index.html; do
		rm -f $file
	done

	insinto "/${MY_HTDOCSDIR}"
	doins -r *

	webapp_serverowned -R "${MY_HTDOCSDIR}/data"
	webapp_src_install
}
