# frozen_string_literal: true

require 'sequel'

module MtgScraper
  DB = Sequel.connect('postgres://localhost/mtg2')
  DB.extension :pg_array
end
