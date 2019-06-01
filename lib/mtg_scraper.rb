# frozen_string_literal: true

require 'nokogiri'
require 'net/http'

module MtgScraper
  module_function

  def call
    MtgScraper::Sets::Extract.call
      .yield_self(&MtgScraper::Sets::Load)
  end
end

require_relative 'mtg_scraper/db'
require_relative 'mtg_scraper/sets'
require_relative 'mtg_scraper/gatherer'
require_relative 'mtg_scraper/sets/extract'
require_relative 'mtg_scraper/sets/load'
