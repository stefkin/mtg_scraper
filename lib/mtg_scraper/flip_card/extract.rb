# frozen_string_literal: true

module MtgScraper::FlipCard::Extract
  module_function

  def call(link)
    [t { MtgScraper::Card::Extract.call(link, css_modifier: 'ctl01') },
     t { MtgScraper::Card::Extract.call(link, css_modifier: 'ctl02') },
     t { MtgScraper::Card::Extract.call(link, css_modifier: 'ctl03') },
     t { MtgScraper::Card::Extract.call(link, css_modifier: 'ctl04') }].compact
  end

  def t
    yield
  rescue StandardError => e
    puts e
    nil
  end

  def to_proc
    method(:call).to_proc
  end
end
