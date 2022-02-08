# Version 0.6

Minimum Ruby version is now Ruby 2.6.

# Version 0.5

Added a way to paginate. Use `paginate: N` to iterate over pages of results.

# Version 0.4.5

Fix timeout being incorrectly called again.

# Version 0.4.4

Fix timeout being incorrectly called.

# Version 0.4.3

Fix warning message for classic tokens. Add time printout to help judge need for
timeout setting.

# Version 0.4.2

Remove broken support for classic tokens. Modern `INDICO_TOKEN` required.

# Version 0.4.1

Fix a few issues in Jekyll generator.

# Version 0.4.0

Support `INDICO_TOKEN`, replaces the [deprecated indico URL
authentication](https://docs.getindico.io/en/stable/http-api/access/). Also
support `indico.timeout` setting in config.

# Version 0.3.0

Support setting or avoiding the cache command message.

# Version 0.2.1

Fix manual caching.

# Version 0.2.0

Support for base URLs. The `indico: url:` parameter is *required*.

# Version 0.1.0

First version to be published, pulled from the IRIS-HEP website.

Extra features added during the transition include:

* Config settings for IDs and data path.
* `jekyll-indico-cache` script has customizable `--config` location.
* Some basic unit testing
* Better separation into files
