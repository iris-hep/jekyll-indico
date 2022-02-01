# frozen_string_literal: true

require 'yaml'

require 'jekyll'

require 'jekyll-indico/core'

require 'net/http'

module JekyllIndico
  # This is a Jekyll Generator
  class GetIndico < Jekyll::Generator
    # Main entry point for Jekyll
    def generate(site)
      @site = site
      @cache_msg = @site.config.dig('indico', 'cache-command')

      timeout = @site.config.dig('indico', 'timeout')
      Net::HTTP.read_timeout = timeout if timeout

      meeting_ids = @site.config.dig('indico', 'ids')
      raise MissingIDs, 'indico: ids: MISSING from your config!' unless meeting_ids
      raise MissingIDs, 'indico: ids: must be a hash!' unless meeting_ids.is_a?(Hash)

      meeting_ids.each do |name, number|
        collect_meeting(name.to_s, number)
      end
    end

    private

    def collect_meeting(name, number)
      base_url = @site.config.dig('indico', 'url')
      raise MissingURL, 'indico: url: MISSING from your config!' unless base_url

      data_path = @site.config.dig('indico', 'data') || 'indico'
      @site.data[data_path] = {} unless @site.data.key? data_path

      # Do nothing if already downloaded
      return if @site.data[data_path].key? name

      msg = @cache_msg ? " - run `#{@cache_msg}` to cache" : ''
      puts "Accessing Indico meeting API for #{name}:#{number}#{msg}"
      iris_meeting = Meetings.new(base_url, number)
      @site.data[data_path][name] = iris_meeting.dict
    end
  end
end
