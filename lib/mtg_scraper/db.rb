# typed: true
# frozen_string_literal: true

require 'sequel'

module MtgScraper
  DB = Sequel.connect('postgres://localhost/mtg')
  DB.extension :pg_array
end
