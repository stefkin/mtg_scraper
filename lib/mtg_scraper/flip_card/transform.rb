# frozen_string_literal: true

module MtgScraper::FlipCard::Transform
  module_function

  def to_proc
    method(:call).to_proc
  end

  def call(cards)
    cards.map(&MtgScraper::Card::Transform)
  end
end
