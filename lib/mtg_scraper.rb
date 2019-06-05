# frozen_string_literal: true

require 'nokogiri'
require 'cgi'
require 'net/http'

module MtgScraper
  module_function

  def call
    MtgScraper::Sets::Extract
      .call
      .tap(&MtgScraper::Sets::Load)
      .map(&MtgScraper::Cards::ETL)
      .map(&:join)
  end
end

require_relative 'mtg_scraper/db'
require_relative 'mtg_scraper/gatherer'
require_relative 'mtg_scraper/retryable'
require_relative 'mtg_scraper/sets'
require_relative 'mtg_scraper/sets/extract'
require_relative 'mtg_scraper/sets/load'
require_relative 'mtg_scraper/card'
require_relative 'mtg_scraper/card/extract'
require_relative 'mtg_scraper/card/transform'
require_relative 'mtg_scraper/card/load'
require_relative 'mtg_scraper/cards'
require_relative 'mtg_scraper/cards/etl'
