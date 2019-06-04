# frozen_string_literal: true

module MtgScraper::Card::Load
  module_function

  def to_proc
    method(:call).to_proc
  end

  def call(card_sides)
    MtgScraper::DB.transaction do
      card_sides
        .map(&method(:sequelize_mana_cost_array))
        .map(&method(:create_card))
        .yield_self(&method(:link_flip_cards))
    end
  end

  def sequelize_mana_cost_array(card)
    card.merge mana_cost: Sequel.pg_array(card[:mana_cost], :text)
  end

  def create_card(card)
    MtgScraper::Card.create(card)
  end

  def link_flip_cards(card_sides)
    return card_sides if card_sides.count == 1

    side_a, side_b = card_sides
    side_a.flip_card = side_b
    side_b.flip_card = side_a
    [side_a, side_b].map(&:save)
  end
end
