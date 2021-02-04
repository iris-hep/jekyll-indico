# frozen_string_literal: true

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
      indico_dir = Pathname.new('_data') / data_path
      folder = indico_dir / name.to_s
      indico_dir.mkdir unless indico_dir.directory?
      folder.mkdir unless folder.directory?

      iris_meeting = JekyllIndico::Meetings.new(base_url, number)
      iris_meeting.to_files(folder) { |key| puts "Making #{folder / key}.yml\n" }
    end
  end
end
