# frozen_string_literal: true


module MtgScraper
  module Sets
    def self.call
      MtgScraper::DB[:sets]
    end
  end
end
