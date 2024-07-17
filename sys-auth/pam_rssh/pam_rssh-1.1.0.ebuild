# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	base64@0.13.1
	bitflags@1.3.2
	byteorder@1.4.3
	cc@1.0.79
	cfg-if@1.0.0
	error-chain@0.12.4
	foreign-types@0.3.2
	foreign-types-shared@0.1.1
	futures@0.1.31
	hostname@0.3.1
	itoa@1.0.6
	libc@0.2.140
	log@0.4.17
	match_cfg@0.1.0
	multisock@1.0.0
	num_threads@0.1.6
	once_cell@1.17.1
	openssl@0.10.55
	openssl-macros@0.1.0
	openssl-sys@0.9.90
	pam-bindings@0.1.1
	pkg-config@0.3.26
	proc-macro2@1.0.52
	pwd@1.4.0
	quote@1.0.26
	serde@1.0.157
	serde_derive@1.0.157
	syn@1.0.109
	syn@2.0.0
	syslog@6.0.1
	thiserror@1.0.40
	thiserror-impl@1.0.40
	time@0.3.20
	time-core@0.1.0
	time-macros@0.2.8
	unicode-ident@1.0.8
	vcpkg@0.2.15
	version_check@0.9.4
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
"

inherit cargo pam

DESCRIPTION="This PAM module provides ssh-agent based authentication"
HOMEPAGE="https://github.com/z4yx/pam_rssh"

SSH_AGENT_COMMIT="802b94ccf2e00ac33a3863300d0769f02b62d807"
SRC_URI="${CARGO_CRATE_URIS}"
SRC_URI+="https://github.com/z4yx/pam_rssh/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/z4yx/ssh-agent.rs/archive/${SSH_AGENT_COMMIT}.tar.gz -> ssh-agent.rs-${SSH_AGENT_COMMIT}.tar.gz"

LICENSE="Apache-2.0 CC-PDDC MIT Unicode-DFS-2016 Unlicense"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	sys-libs/pam
	dev-libs/openssl
"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	cargo_src_unpack

	rmdir "${WORKDIR}/${P}/dep/ssh-agent.rs"
	cp -r "${WORKDIR}/ssh-agent.rs-${SSH_AGENT_COMMIT}" "${WORKDIR}/${P}/dep/ssh-agent.rs" \
		|| die "Failed to copy ssh-agent.rs into workdir"
}

src_install() {
	dopammod target/release/libpam_rssh.so
}

pkg_postinst() {
	ewarn "Default parameter auth_key_file is insecure"
	ewarn "Reference: https://github.com/z4yx/pam_rssh/issues/17 and linked issue"

	einfo "Suggestion is to set auth_key_file to a location not writeable by users"
	einfo "such as /etc/ssh/authorized_keys.d/authorized_keys"
}
