require_relative "lib/mtg_scraper"

task :scrape do
  MtgScraper.call
end

task :init_db do
  MtgScraper::DB.drop_table(:sets)
  MtgScraper::DB.create_table(:sets) do
    primary_key :id
    String :name, null: false, unique: true
  end
end

task default: %i[init_db scrape]
