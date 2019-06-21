# typed: true
# frozen_string_literal: true

module MtgScraper::Card::Load
  include Kernel
  extend T::Sig
  extend MtgScraper::Procify
  extend self

  sig { params(card_sides: T::Array[T::Card]).returns(T::Array[MtgScraper::Card]) }
  def call(card_sides)
    MtgScraper::DB.transaction do
      card_sides
        .map(&method(:sequelize_mana_cost_array))
        .map(&method(:create_card))
        .yield_self(&method(:link_flip_cards))
    end
  end

  sig { params(card: T::Card).returns(T::Card) }
  def sequelize_mana_cost_array(card)
    card.merge mana_cost: Sequel.pg_array(card[:mana_cost], :text)
  end

  sig { params(card: T::Card).returns(MtgScraper::Card) }
  def create_card(card)
    MtgScraper::Card.create(card)
  end

  sig { params(card_sides: T::Array[MtgScraper::Card]).returns(T::Array[MtgScraper::Card]) }
  def link_flip_cards(card_sides)
    return card_sides if card_sides.count == 1

    side_a, side_b = card_sides
    T.must(side_a).flip_card = side_b
    T.must(side_b).flip_card = side_a
    [side_a, side_b].compact.map(&:save)
  end
end
