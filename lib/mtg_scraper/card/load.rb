# frozen_string_literal: true

module MtgScraper::Card::Load
  module_function

  def to_proc
    method(:call).to_proc
  end

  def call(card)
    card[:mana_cost] = Sequel.pg_array(card[:mana_cost])
    MtgScraper::DB[:cards].insert(card)
  end
end
