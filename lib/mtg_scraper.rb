# frozen_string_literal: true

require 'nokogiri'
require 'cgi'
require 'net/http'

module MtgScraper
  module_function

  def call
    MtgScraper::Set::Extract
      .call
      .tap(&MtgScraper::Set::Load)
      .map(&MtgScraper::Card::ETL)
      .map(&:join)
  end
end

require_relative 'mtg_scraper/db'
require_relative 'mtg_scraper/gatherer'
require_relative 'mtg_scraper/procify'
require_relative 'mtg_scraper/retryable'
require_relative 'mtg_scraper/set'
require_relative 'mtg_scraper/set/extract'
require_relative 'mtg_scraper/set/load'
require_relative 'mtg_scraper/card'
require_relative 'mtg_scraper/card/extract'
require_relative 'mtg_scraper/card/transform'
require_relative 'mtg_scraper/card/load'
require_relative 'mtg_scraper/card/etl'
