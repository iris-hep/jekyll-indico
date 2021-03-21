# frozen_string_literal: true

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

      meeting_ids = Meetings.meeting_ids(@site.config)
      meeting_ids.each do |name, number|
        collect_meeting(name.to_s, number)
      end
    end

    private

    def collect_meeting(name, number)
      base_url = Meetings.base_url(@site.config)

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
