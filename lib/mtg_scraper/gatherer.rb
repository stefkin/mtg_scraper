# frozen_string_literal: true

module Gatherer
  module_function

  BASE_URL = 'https://gatherer.wizards.com'

  def build_path(*parts, params)
    query = URI.encode_www_form(params.to_a)
    url = [BASE_URL, *parts].join('/')
    URI [url, query].reject(&:empty?).join('?')
  end

  def sets_url
    build_path('Pages', 'Default.aspx', {})
  end

  def cards_url(set_name, query)
    build_path('Pages', 'Search', 'Default.aspx', query.merge(set: "[\"#{set_name}\"]"))
  end
end
