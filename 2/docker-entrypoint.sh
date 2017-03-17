#!/usr/bin/env ash

rundir=${rundir:-/var/run/transmission}
pidfile=${pidfile:-${rundir}/transmission.pid}
config_dir=${config_dir:-/var/lib/transmission/config}
download_dir=${download_dir:-/var/lib/transmission/downloads}
runas_user=${runas_user:-transmission:transmission}

# if command starts with an option, prepend transmission-daemon
if [ "${1:0:1}" = '-' ]; then
	set -- transmission-daemon "$@"
fi

_check_config() {
	# use default config directory in case no config-dir option was passed
	if ! $(echo "${TRANSMISSION_OPTIONS}" | grep -q -e '\B-g' -e '\B--config-dir'); then
		TRANSMISSION_OPTIONS="${TRANSMISSION_OPTIONS} -g ${config_dir}"

		# perform on first run only
		if [ ! -f ${config_dir}/settings.json ]; then
			# set download dir and pid file location
			TRANSMISSION_OPTIONS="${TRANSMISSION_OPTIONS} -w ${download_dir} -x ${pidfile}"

			# create default directories
			for dir in "$rundir" "$config_dir" "$download_dir"; do
				mkdir -p "${dir}"
				if [ -n "${runas_user:-}" ]; then
					chown -R ${runas_user} "${dir}"
				fi
			done
		fi
	fi
}

if [ "$1" = 'transmission-daemon' ]; then
	shift
	TRANSMISSION_OPTIONS="-f ${TRANSMISSION_OPTIONS} $@"
	_check_config
	exec su-exec "${runas_user}" transmission-daemon ${TRANSMISSION_OPTIONS}
fi

exec "$@"
