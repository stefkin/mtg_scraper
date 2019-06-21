# typed: true
# frozen_string_literal: true

module MtgScraper::Set::Load
  extend T::Sig
  extend MtgScraper::Procify
  extend self

  sig { params(set_names: T::Array[String]).returns(T::Array[String]) }
  def call(set_names)
    set_names.each { |name| MtgScraper::Set.create(name: name) }
  end
end
