#!/bin/bash
set -eo pipefail

declare -A aliases=(
	[2]='latest'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( */ )
versions=( "${versions[@]%/}" )

# get the most recent commit which modified any of "$@"
fileCommit() {
	git log -1 --format='format:%H' HEAD -- "$@"
}

# get the most recent commit which modified "$1/Dockerfile" or any file COPY'd from "$1/Dockerfile"
dirCommit() {
	local dir="$1"; shift
	(
		cd "$dir"
		fileCommit \
			Dockerfile \
			$(git show HEAD:./Dockerfile | awk '
				toupper($1) == "COPY" {
					for (i = 2; i < NF; i++) {
						print $i
					}
				}
			')
	)
}

# prints "$2$1$3$1...$N"
join() {
	local sep="$1"; shift
	local out; printf -v out "${sep//%/%%}\`%s\`" "$@"
	echo "${out#$sep}"
}

for version in "${versions[@]}"; do
	[ -f "$version/Dockerfile" ] || continue

	commit="$(dirCommit "$version")"

	fullVersion="$(git show "$commit":"$version/Dockerfile" | awk '$1 == "ENV" && $2 == "TD_VERSION" { print $3; exit }')" # 2.93.0-r3
	fullVersion="${fullVersion%%-*}" # 2.93.0

	versionAliases=()
	while [ "$fullVersion" != "$version" ]; do
		versionAliases+=( $fullVersion )
		fullVersion="${fullVersion%.*}"
	done
	versionAliases+=(
		$version
		${aliases[$version]:-}
	)

	cat <<-EOE
	* $(join ', ' "${versionAliases[@]}") [($version/Dockerfile)](https://github.com/antoineco/transmission-daemon/blob/$commit/$version/Dockerfile)
	EOE
done
