A Jekyll plugin (Ruby gem) that pulls meeting lists from an [Indico](https://getindico.io) instance and exposes them to Liquid templates, with an option to cache the results to `_data` for offline site builds.

## Commands

```bash
bundle config set --local path 'vendor/bundle'  # one-time: keep bundle local
bundle install

bundle exec rake               # default: rubocop + rspec (full check)
bundle exec rake spec          # tests only
bundle exec rake rubocop       # lint only
bundle exec rake rubocop:auto_correct  # autofix lint

bundle exec rspec spec/jekyll-indico_spec.rb -e 'has expected contents'  # single test
```

The specs hit the live `https://indico.cern.ch` API (no mocking/VCR), so they need network access and assert on real historical meeting data.

Linting beyond rubocop runs via `prek -a --quiet` (whitespace, line endings, no tabs, yaml checks — see `.pre-commit-config.yaml`).

Release: bump `lib/jekyll-indico/version.rb`, run `bundle install`, then `bundle exec rake release` (tags, pushes, publishes to RubyGems).

## Architecture

Two entry points share one core:

- `lib/jekyll-indico/core.rb` — `JekyllIndico::Meetings`. The only code that talks to Indico. Its constructor downloads and parses results immediately, transforming each meeting into `@dict` keyed by start date (`YYYYMMDD`). Handles pagination (`limit`/`paginate`, auto-iterating until a short page), timeouts, YouTube-URL extraction from descriptions, and `<p>` trimming. Auth: `INDICO_TOKEN` env var → Bearer header; the old `INDICO_API_KEY`/`INDICO_SECRET_KEY` vars now raise an error.
- `lib/jekyll-indico/generator.rb` — `GetIndico < Jekyll::Generator`, loaded by default via `lib/jekyll-indico.rb` (the gem's required file). Runs during a Jekyll build, reading config under the top-level `indico:` key and populating `site.data[data_path][name]` in memory. Skips any `name` already present in `site.data` (i.e. already cached on disk).
- `lib/jekyll-indico/cache.rb` + `exe/jekyll-indico-cache` — CLI path. Reuses `Meetings` to write `_data/<data_path>/<name>/<YYYYMMDD>.yml` files so the generator's skip logic picks them up on later builds.

Config lives under `indico:` in the site's `_config.yml`: required `url` and `ids` (a hash of name → Indico category ID); optional `data`, `paginate`, `timeout`, `cache-command`. The generator and the CLI parse this config independently — keep their validation and defaults (`data` defaults to `'indico'`) in sync.

Ruby ≥ 2.6, Jekyll 3.8–4.x.
