# frozen_string_literal: true

module MtgScraper::Card::Transform
  module_function

  def to_proc
    method(:call).to_proc
  end

  def call(card_sides)
    card_sides.map do |card|
      relative_url = card[:image_url]
      absolute_url = Gatherer.build_path relative_url[6..-1], {}
      card[:image_url] = absolute_url.to_s

      card[:set_id] = MtgScraper::DB[:sets].where(name: card.delete(:set)).first[:id]

      card[:converted_mana_cost] ||= 0

      power, toughness = card.delete(:power_and_toughness)
                             .split('/')
                             .map(&:strip)
      card[:power] = power
      card[:toughness] = toughness

      card
    end
  end
end
