# typed: true
# frozen_string_literal: true

module MtgScraper::Set::Extract
  extend T::Sig
  extend MtgScraper::Procify
  extend self

  sig { returns(T::Array[String]) }
  def call
    Net::HTTP
      .get(Gatherer.sets_url)
      .yield_self { |raw_html| Nokogiri::HTML(raw_html) }
      .search('select#ctl00_ctl00_MainContent_Content_SearchControls_setAddText option')
      .map(&:content)
      .reject(&:empty?)
  end
end
