xgit_enable() {
	local top=$(readlink -f "${1:-$PWD}")
	if [ ! -d "$top/git" -o ! -d "$top/gitwd" ]; then
		echo "git/ and gitwd/ must exist" >&2
		return 2
	fi
	export XGIT_TOP="$top"
	export GIT_DIR=$(readlink -f "$top/git")
	export GIT_WORK_TREE=$(readlink -f "$top/gitwd")
	export XGIT_OLD_PS1="$PS1"
	export PS1=$(echo "$PS1"|perl -pe 's/(\\w\\\$)(\s*)$/(xgit \$XGIT_TOP)\1\2/')
}
xgit_disable() {
	unset GIT_DIR GIT_WORK_TREE XGIT_TOP
	[ "$XGIT_OLD_PS1" != "" ] && export PS1="$XGIT_OLD_PS1"
	unset XGIT_OLD_PS1
}

xgit() {
	if [ "$XGIT_TOP" = "" ]; then
		xgit_enable "$1"
	else
		xgit_disable
	fi
}
