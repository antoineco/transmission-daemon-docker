# Supported tags and respective `Dockerfile` links

* `2.92`, `2`, `latest` [(2/Dockerfile)](https://github.com/antoineco/transmission-daemon/blob/e0328e5dcac83313314f94809555ceb2401c1811/2/Dockerfile)

# What is Transmission?

Transmission is a cross-platform BitTorrent client that is Open-source, Easy, Lean, Native and Powerful.

> [Transmission project page][transmission]

![Transmission][banner]

# What is the `transmission-daemon` image?

A very minimal image meant to run the Transmission daemon and nothing else.

# How to use the `transmission-daemon` image?

The Transmission daemon can be configured at run time using configuration flags, which can be passed either directly as the container command or via the `TRANSMISSION_OPTIONS` environment variable.

For a list of all available options, please run `docker run --rm antoineco/transmission-daemon -h` or check the [project documentation][transmission-docs].

The `--foreground` flag is set automatically by the startup script in order to prevent the process from running as a deamon.

Besides, the following default directories are created and used automatically if `--config-dir` is not set:

| Directory                         | Override env var | Used for flag  |
|-----------------------------------|------------------|----------------|
| `/var/lib/transmission/config`    | config_dir       | --config-dir   |
| `/var/lib/transmission/downloads` | download_dir     | --download-dir |
| `/var/run/transmission`           | rundir           | --pid-file     |

Usage example:

```
$ docker run \
	-v /myconfig -v /mydownloads \
	-e config_dir=/myconfig -e download_dir=/mydownloads \
	antoineco/transmission-daemon \
		--auth \
		--username foo \
		--password bar \
		--port 9090
```

[banner]: https://raw.githubusercontent.com/antoineco/transmission-daemon/master/logo.png
[transmission]: https://transmissionbt.com/
[transmission-docs]: https://trac.transmissionbt.com/
