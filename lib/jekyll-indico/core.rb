# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require 'date'
require 'time'
require 'openssl'

module JekyllIndico
  class Error < StandardError
  end

  class MissingURL < Error
  end

  class MissingIDs < Error
  end

  # Look for topical meetings
  class Meetings
    attr_accessor :dict

    # ID for IRIS-HEP: 10570
    def initialize(base_url, indico_id, **kargs)
      @dict = {}

      download_and_iterate(base_url, indico_id, **kargs) do |i|
        # Trim paragraph tags
        d = i['description']
        d = d[3..-1] if d.start_with? '<p>'
        d = d[0..-5] if d.end_with? '</p>'

        start_date = Date.parse i['startDate']['date']
        fname = start_date.strftime('%Y%m%d').to_s

        youtube = ''
        urllist = URI.extract(d)
        urllist.each do |url|
          youtube = url if url.include?('youtube') || url.include?('youtu.be')
        end

        @dict[fname] = {
          'name' => i['title'],
          'startdate' => start_date,
          'meetingurl' => i['url'],
          'location' => i['location'],
          'youtube' => youtube,
          'description' => d
        }
      end
    end

    # Write out files (Folder given, by key name)
    def to_files(folder)
      @dict.each do |key, dict|
        yield key if block_given?
        File.write(folder / "#{key}.yml", dict.to_yaml)
      end
    end

    private

    # Run a block over each item in the downloaded results
    def download_and_iterate(base_url, indico_id, timeout: nil, **params, &block)
      params[:pretty] = 'no'
      uri = URI.join(base_url, "/export/categ/#{indico_id}.json")
      uri.query = URI.encode_www_form(params)

      req = Net::HTTP::Get.new(uri)
      if ENV['INDICO_TOKEN']
        req['Authorization'] = "Bearer #{ENV['INDICO_TOKEN']}"
      elsif ENV['INDICO_SECRET_KEY'] || ENV['INDICO_API_KEY']
        raise Error, 'Use INDICO_TOKEN with a new-style token'
      end

      opts = { use_ssl: true }
      opts[:read_timeout] = timeout if timeout

      response = Net::HTTP.start(uri.hostname, uri.port, **opts) { |http| http.request(req) }

      string = response.body
      parsed = JSON.parse(string) # returns a hash

      parsed['results'].each(&block)
    end
  end
end
