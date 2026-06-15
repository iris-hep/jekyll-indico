# frozen_string_literal: true

require 'fileutils'
require 'pathname'
require 'yaml'

require 'jekyll-indico/core'

# The main module for this package.
module JekyllIndico
  # This will cache the hash of meeting IDs given into the data_path in _data
  # in the current directory.
  def self.cache(base_url, meeting_ids, data_path)
    meeting_ids.each do |name, number|
      yield name, number
      folder = Pathname.new('_data') / data_path / name.to_s
      FileUtils.mkdir_p(folder)

      iris_meeting = JekyllIndico::Meetings.new(base_url, number)
      iris_meeting.to_files(folder) { |key| puts "Making #{folder / key}.yml\n" }
    end
  end
end
