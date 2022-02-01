# Jekyll-Indico

[![Gem Version](https://badge.fury.io/rb/jekyll-indico.svg)](https://badge.fury.io/rb/jekyll-indico)
[![CI](https://github.com/iris-hep/jekyll-indico/workflows/CI/badge.svg)](https://github.com/iris-hep/jekyll-indico/actions?query=workflow%3ACI)

This is a tool for importing meeting information from Indico.

#### Setup: config

Your `_config.yaml` file should contain the categories you want to download:

```yaml
indico:
  url: https://indico.cern.ch # Indico instance to use (REQUIRED)
  data: indico # Optional, folder name in _data to use
  cache-command: bundle exec rake cache # Optional, user msg if you support it
  ids:
    topical: 10570
    blueprint: 11329
```

This plugin will automatically use an API token if your environment contains
`INDICO_TOKEN`. You should generate this and replace `INDICO_API` and
`INDICO_SECRET_KEY` with it. You'll want the "Classic API" read permissions set
on it.

#### Usage: installing


You should add this gem to your Gemfile:

```ruby
group :jekyll_plugins do
  gem "jekyll-indico"
end
```

Jekyll will use any plugin listed in this Gemfile group.

#### Usage: caching

If you want to cache for local website development, you can run:

```bash
bundle exec jekyll-indico-cache --config _config.yaml
```

Or, if you use rake, you can add a task like this:

```ruby
task: cache do
  sh 'jekyll-indico-cache'
end
```

Now the "cache" task will cache your Indico reads.


#### Internals

This works by calling the Indico API and pulling meeting information, then
storing it in `site.data[config.indico.data][config.indico.id][number]` (or
caching it in
`_data/<config.indico.data>/<config.indico.id.key>/<number>.yml`). This then
available directly in liquid from this location. You can have as many ids as
you want (key is a category name that you select, the value is the group ID
number on Indico).

#### Setting up for development:


```bash
# Install a local bundle
bundle config set --local path 'vendor/bundle'

# Test style and unit tests
bundle exec rake
```

If you need to automatically correct unit paths:

```bash
bundle exec rake rubocop:auto_correct
```

To release, make sure the version in `lib/jekyll-indico/version.rb` is new and
you have updated your lock file with `bundle install` then:

```bash
bundle exec rake release
```

This tags, pushes the tag, and publishes.
