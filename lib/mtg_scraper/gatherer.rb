# typed: true
# frozen_string_literal: true

module Gatherer
  extend T::Sig
  include Kernel
  module_function

  BASE_URL = 'https://gatherer.wizards.com'

  sig { params(parts: String, params: Hash).returns(URI::Generic) }
  def build_path(*parts, params:)
    query = URI.encode_www_form(params.to_a)
    url = [BASE_URL, *parts].join('/')
    URI([url, query].reject(&:empty?).join('?'))
  end

  sig { returns(URI::Generic) }
  def sets_url
    build_path('Pages', 'Default.aspx', params: {})
  end

  sig { params(set_name: String, query: Hash).returns(URI::Generic) }
  def cards_url(set_name, query)
    build_path('Pages', 'Search', 'Default.aspx', params: query.merge(set: "[\"#{set_name}\"]"))
  end
end
