# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} )
WANT_AUTOMAKE="1.13"

inherit user eutils multilib flag-o-matic autotools distutils-r1

DESCRIPTION="389 Directory Server (core librares and daemons )"
HOMEPAGE="https://pagure.io/${PN}"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://pagure.io/${PN}.git"
	EGIT_BOOTSTRAP=""
	KEYWORDS=""
	S="${WORKDIR}/${PN}"
else
	SRC_URI="https://releases.pagure.org/${PN}/${PN}-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="autobind auto-dn-suffix debug doc +pam-passthru +dna +ldapi +bitwise selinux test"

# Pinned to db:4.8 as it is the current stable, can change to a later db version < 6 when they stabilize.
# The --with-db-inc line in econf will need to be updated as well when changing db version.
COMMON_DEPEND="
	sys-libs/db:4.8
	>=dev-libs/cyrus-sasl-2.1.19
	>=net-analyzer/net-snmp-5.1.2
	>=dev-libs/icu-3.4:=
	>=dev-libs/nss-3.22[utils]
	dev-libs/nspr
	dev-libs/openssl:0=
	dev-libs/libpcre:3
	dev-perl/NetAddr-IP
	net-nds/openldap
	sys-libs/libxcrypt
	sys-libs/pam
	sys-libs/zlib
	dev-libs/libevent
	dev-util/cmocka
	dev-python/six"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	dev-python/argparse-manpage
	dev-python/packaging"

RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-dirsrv )
	virtual/perl-Time-Local
	virtual/perl-MIME-Base64
	dev-python/python-ldap
	dev-python/argcomplete
	dev-python/python-dateutil"

pkg_setup() {
	enewgroup dirsrv
	enewuser dirsrv -1 -1 -1 dirsrv
}

src_prepare() {
	# as per 389 documentation, when 64bit, export USE_64
	use amd64 && export USE_64=1

	eautoreconf

	# Ensure we find crypt.h from sys-libs/libxcrypt
	append-flags -I/usr/include/xcrypt
	append-ldflags -L/usr/lib64/xcrypt -Wl,-rpath,/usr/lib64/xcrypt

	append-lfs-flags

	distutils-r1_src_prepare
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable pam-passthru) \
		$(use_enable ldapi) \
		$(use_enable autobind) \
		$(use_enable dna) \
		$(use_enable bitwise) \
		$(use_enable auto-dn-suffix) \
		$(use_enable test cmocka) \
		--with-initddir=no \
		--enable-maintainer-mode \
		--with-fhs \
		--with-openldap \
		--sbindir=/usr/sbin \
		--bindir=/usr/bin \
		--with-db-inc=/usr/include/db4.8

}

src_compile() {
	emake
	cd "${S}/src/lib389" || die
	distutils-r1_src_compile

	if use doc; then
		doxygen docs/slapi.doxy || die "cannot run doxygen"
	fi
}

python_compile() {
	distutils-r1_python_compile build_manpages
}

src_test () {
	# -j1 is a temporary workaround for bug #605432
	emake -j1 check
}

src_install () {
	# -j1 is a temporary workaround for bug #605432
	emake -j1 DESTDIR="${D}" install

	cd "${S}/src/lib389" || die
	distutils-r1_src_install

	# Install gentoo style init script
	# Get these merged upstream
	newinitd "${FILESDIR}"/389-ds.initd-r1 389-ds
	newinitd "${FILESDIR}"/389-ds-snmp.initd 389-ds-snmp

	# cope with libraries being in /usr/lib/dirsrv
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/dirsrv" > "${D}"/etc/env.d/08dirsrv

	if use doc; then
		cd "${S}" || die
		docinto html/
		dodoc -r docs/html/.
	fi

	# Ensure directories exists and fix permissions
	dodir /var/lib/dirsrv
	dodir /var/log/dirsrv
	fowners dirsrv:dirsrv /var/lib/dirsrv
	fowners dirsrv:dirsrv /var/log/dirsrv
}

pkg_postinst() {
	echo
	elog "If you are planning to use 389-ds-snmp (ldap-agent),"
	elog "make sure to properly configure: /etc/dirsrv/config/ldap-agent.conf"
	elog "adding proper 'server' entries, and adding the lines below to"
	elog " => /etc/snmp/snmpd.conf"
	elog
	elog "master agentx"
	elog "agentXSocket /var/agentx/master"
	elog
	elog "To start 389 Directory Server (LDAP service) at boot:"
	elog
	elog "    rc-update add 389-ds default"
	elog
	echo
}
