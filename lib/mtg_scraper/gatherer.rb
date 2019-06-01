# frozen_string_literal: true

module Gatherer
  module_function

  BASE_URL = 'https://gatherer.wizards.com'

  def build_path(*parts)
    URI [BASE_URL, *parts].join('/')
  end

  def sets_url
    build_path('Pages', 'Default.aspx')
  end
end
