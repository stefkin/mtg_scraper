# frozen_string_literal: true

module MtgScraper::Card::Transform
  module_function

  def to_proc
    method(:call).to_proc
  end

  def call(card)
    relative_url = card[:image_url]
    absolute_url = Gatherer.build_path relative_url[6..-1], {}
    set_id = MtgScraper::DB[:sets].where(name: card[:set]).first[:id]
    card.delete(:set)
    card.merge(image_url: absolute_url.to_s, set_id: set_id)
  end
end
