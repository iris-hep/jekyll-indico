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
    def initialize(base_url, indico_id, limit: nil, **kargs)
      @dict = {}

      download_and_iterate(base_url, indico_id, limit: limit, **kargs) do |i|
        # Trim paragraph tags
        d = i['description']
        d = d[3..] if d.start_with? '<p>'
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

    def get_parsed_results(base_url, indico_id, timeout: nil, **params)
      opts = { use_ssl: true }
      opts[:read_timeout] = timeout if timeout

      uri = URI.join(base_url, "/export/categ/#{indico_id}.json")
      uri.query = URI.encode_www_form(params)

      req = Net::HTTP::Get.new(uri)
      if ENV['INDICO_TOKEN']
        req['Authorization'] = "Bearer #{ENV.fetch('INDICO_TOKEN', nil)}"
      elsif ENV.fetch('INDICO_SECRET_KEY', nil) || ENV.fetch('INDICO_API_KEY', nil)
        raise Error, 'Use INDICO_TOKEN with a new-style token'
      end

      response = Net::HTTP.start(uri.hostname, uri.port, **opts) { |http| http.request(req) }

      parsed = JSON.parse(response.body)
      parsed['results']
    end

    # Run a block over each item in the downloaded results
    def download_and_iterate(base_url, indico_id, limit: nil, **params, &block)
      limit = nil if limit.zero?
      params[:limit] = limit if limit
      params[:pretty] = 'no'

      unless limit
        results = get_parsed_results(base_url, indico_id, **params)
        results.each(&block)
        return
      end

      0.step.each do |n|
        results = get_parsed_results(base_url, indico_id, offset: n * limit, **params)
        results.each(&block)
        break if results.length < limit
      end
    end
  end
end
