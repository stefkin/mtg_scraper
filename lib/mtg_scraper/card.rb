class MtgScraper::Card < Sequel::Model
  one_to_one :flip_card, class: self, key: :flip_card_id
end
