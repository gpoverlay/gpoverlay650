# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

IUSE=""
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI=${EGIT_REPO_URI:-"https://github.com/thewtex/tmux-mem-cpu-load.git"}
	SRC_URI=""
else
	KEYWORDS=""
	SRC_URI="https://github.com/thewtex/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="CPU, RAM memory, and load monitor for use with tmux"
HOMEPAGE="https://github.com/thewtex/tmux-mem-cpu-load/"

LICENSE="Apache-2.0"
SLOT="0"

DOCS=( AUTHORS README.rst )
