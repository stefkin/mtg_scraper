require_relative "lib/mtg_scraper"

task :scrape do
  MtgScraper.call
end

task :init_db do
  MtgScraper::DB.drop_table(:cards)
  MtgScraper::DB.drop_table(:sets)

  MtgScraper::DB.create_table(:sets) do
    primary_key :id
    String :name, null: false, unique: true
  end

  MtgScraper::DB.create_table(:cards) do
    primary_key :id
    Bigint :multiverse_id, null: false, unique: true
    String :name, null: false, unique: true
    String :text, null: false
    add_column :mana_cost, type: 'text[]', null: false
    Integer :converted_mana_cost, null: false
    String :types, null: false
    Integer :power
    Integer :toughness
    foreign_key :set_id, :sets
    String :rarity, null: false
    Integer :number, null: false
    String :artist, null: false
    String :image_url, null: false

    index [:set_id, :name]
    index :name
  end
end

task default: %i[init_db scrape]
