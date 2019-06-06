# frozen_string_literal: true

module MtgScraper::Set::Load
  extend MtgScraper::Procify
  extend self

  def call(set_names)
    set_names.each { |name| MtgScraper::Set.create(name: name) }
  end
end
