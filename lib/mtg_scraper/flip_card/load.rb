# frozen_string_literal: true

module MtgScraper::FlipCard::Load
  module_function

  def to_proc
    method(:call).to_proc
  end

  def call(cards)
    a_side, b_side = cards.map do |card|
      card[:mana_cost] = Sequel.pg_array(card[:mana_cost], :text)
      MtgScraper::Card.new(card)
    end

    MtgScraper::DB.transaction do
      [a_side, b_side].each(&:save)

      a_side.flip_card = b_side
      b_side.flip_card = a_side

      [a_side, b_side].each(&:save)
    end
  end
end
