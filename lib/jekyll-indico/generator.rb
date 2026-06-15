# frozen_string_literal: true

require 'benchmark'
require 'net/http'
require 'yaml'

require 'jekyll'

require 'jekyll-indico/core'

module JekyllIndico
  # This is a Jekyll Generator
  class GetIndico < Jekyll::Generator
    # Main entry point for Jekyll
    def generate(site)
      @site = site
      @cache_msg = @site.config.dig('indico', 'cache-command')
      @config = JekyllIndico.config_from(@site.config['indico'])

      @config[:ids].each do |name, number|
        collect_meeting(name.to_s, number)
      end
    end

    private

    def collect_meeting(name, number)
      base_url = @config[:url]
      data_path = @config[:data]
      @site.data[data_path] = {} unless @site.data.key? data_path

      timeout = @site.config.dig('indico', 'timeout')
      limit = @site.config.dig('indico', 'paginate')

      # Do nothing if already downloaded
      return if @site.data[data_path].key? name

      msg = @cache_msg ? " - run `#{@cache_msg}` to cache" : ''
      print "Accessing Indico meeting API for #{name}:#{number}#{msg}"
      time = Benchmark.realtime do
        iris_meeting = Meetings.new(base_url, number, timeout: timeout, limit: limit)
        @site.data[data_path][name] = iris_meeting.dict
      end
      puts ", took #{time.round(1)} s"
    end
  end
end
