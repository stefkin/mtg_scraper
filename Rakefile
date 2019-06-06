task :scrape do
  require_relative 'lib/mtg_scraper'
  MtgScraper.call
end

namespace :db do
  require_relative 'lib/mtg_scraper/db'

  task :drop do
    MtgScraper::DB.drop_table(:cards)
    MtgScraper::DB.drop_table(:sets)
  end

  task :create do
    MtgScraper::DB.create_table(:sets) do
      primary_key :id
      String :name, null: false, unique: true
    end

    MtgScraper::DB.create_table(:cards) do
      primary_key :id
      Bigint :multiverse_id, null: false
      String :name, null: false
      String :text, null: false
      add_column :mana_cost, type: 'text[]'
      Integer :converted_mana_cost
      String :types, null: false
      String :power
      String :toughness
      foreign_key :set_id, :sets
      foreign_key :flip_card_id, :cards
      String :rarity, null: false
      String :number
      String :artist, null: false
      String :image_url, null: false
      String :flavor_text

      index [:set_id, :name]
      index :name
    end
  end
end
