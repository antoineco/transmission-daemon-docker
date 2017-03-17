#!/bin/bash
set -eo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( */ )
versions=( "${versions[@]%/}" )

for version in "${versions[@]}"; do
	[ -f "$version/Dockerfile" ] || continue

	packageVersions=()
	for repo in main community; do
		packageVersions+=(
			$(curl -sS http://dl-cdn.alpinelinux.org/alpine/v3.5/$repo/x86_64/APKINDEX.tar.gz |
				tar -xzO APKINDEX |
				( grep transmission-daemon -A 12 || : ) |
				awk -F':' '$1=="V" {print $2; exit}'
			)
		)
	done

	fullVersion="$(printf "%s\n" "${packageVersions[@]}" | sort -V | tail -1)"

	sed -i \
		-e 's/^\(ENV TD_VERSION\) .*/\1 '"$fullVersion"'/' \
		"$version/Dockerfile"
done
