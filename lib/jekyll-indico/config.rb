# frozen_string_literal: true

# The main module for this package.
module JekyllIndico
  # Validate the `indico:` config hash and return its common values.
  # Raises MissingURL / MissingIDs (with the documented messages) on bad input.
  def self.config_from(indico_hash)
    url = indico_hash&.dig('url')
    raise MissingURL, 'indico: url: MISSING from your config!' unless url

    ids = indico_hash&.dig('ids')
    raise MissingIDs, 'indico: ids: MISSING from your config!' unless ids
    raise MissingIDs, 'indico: ids: must be a hash!' unless ids.is_a?(Hash)

    {
      url: url,
      ids: ids,
      data: indico_hash&.dig('data') || 'indico'
    }
  end
end
