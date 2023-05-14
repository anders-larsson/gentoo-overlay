# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term-0.12.1
	atty-0.2.14
	bitflags-1.3.2
	cfg-if-1.0.0
	clap-2.34.0
	hermit-abi-0.1.19
	hermit-abi-0.3.1
	input-0.8.2
	input-sys-1.17.0
	io-lifetimes-1.0.10
	libc-0.2.143
	libudev-sys-0.1.4
	log-0.4.17
	pkg-config-0.3.27
	strsim-0.8.0
	textwrap-0.11.0
	udev-0.7.0
	unicode-width-0.1.10
	vec_map-0.8.2
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.48.0
	windows-targets-0.48.0
	windows_aarch64_gnullvm-0.48.0
	windows_aarch64_msvc-0.48.0
	windows_i686_gnu-0.48.0
	windows_i686_msvc-0.48.0
	windows_x86_64_gnu-0.48.0
	windows_x86_64_gnullvm-0.48.0
	windows_x86_64_msvc-0.48.0
"

inherit cargo

DESCRIPTION="Push-to-Talk with libinput"
HOMEPAGE="https://gitlab.com/somini/inpulse-to-talk"
SRC_URI="$(cargo_crate_uris)"
SRC_URI+=" https://gitlab.com/somini/inpulse-to-talk/-/archive/v${PV}/inpulse-to-talk-v${PV}.tar.bz2"
IUSE="policykit scripts"
S="${WORKDIR}/${PN}-v${PV}"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/libinput
	policykit? ( sys-auth/polkit )"
RDEPEND="${DEPEND}"
BDEPEND=""

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	if use policykit; then
		eapply polkit/polkit.patch
	fi

	eapply_user
}

src_install() {
	cargo_src_install

	if use policykit; then
		insinto /usr/share/polkit-1/actions
		doins polkit/xyz.somini.inpulse-to-talk.run.policy
	fi

	if use scripts; then
		exeinto /usr/bin
		for bin in inpulse-*; do
			doexe $script
		done
	fi
}

pkg_postinst() {
	if use policykit; then
		einfo ""
		einfo "USE flag policykit enabled. Installing policykit action."
		einfo "Policykit rule file is not installed. Create rule and add it to"
		einfo "/etc/polkit-1/rules.d. Example exists on project page."
		einfo ""
	fi
}
