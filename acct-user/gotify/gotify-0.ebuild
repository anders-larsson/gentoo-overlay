# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for www-servers/gotify-server{,-bin}"

ACCT_USER_ID=-1
ACCT_USER_HOME="/var/lib/gotify"
ACCT_USER_GROUPS=( gotify )

acct-user_add_deps
