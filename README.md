This is a tool for importing meeting information from Indico.

#### Setup: config

Your `_config.yaml` file should contain the categories you want to download:

```yaml
indico:
  ids:
    topical: 10570
    blueprint: 11329
```


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

<!-- Feature not added yet
Or, if you use rake, you can add the provided task:

```ruby
require 'jekyll-indico/rake_task'

JekyllIndico::RakeTask.new(:cache)
```

Now the "cache" task will cache your Indico reads.
-->

#### Setting up for development:


```bash
# Install a local bundle
bundle install --path vendor/bundle

# Test style and unit tests
bundle exec rake
```

