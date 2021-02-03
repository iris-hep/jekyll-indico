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

      meeting_ids = Meetings.meeting_ids(@site.config)
      meeting_ids.each do |name, number|
        collect_meeting name.to_s, number
      end
    end

    private

    def collect_meeting(name, number)
      data_path = @site.config.dig('indico', 'data') || 'indico'
      @site.data[data_path] = {} unless @site.data.key? data_path

      # Do nothing if already downloaded
      return if @site.data[data_path].key? name

      puts "Accessing Indico meeting API for #{name}:#{number} " \
           '- run `bundle exec rake cache` to cache'
      iris_meeting = Meetings.new(number)
      @site.data[data_path][name] = iris_meeting.dict
    end
  end
end
