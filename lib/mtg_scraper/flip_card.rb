# frozen_string_literal: true

class MtgScraper::FlipCard
  def appears_on?(link)
    Net::HTTP.get(link)
      .yield_self { |raw_html| Nokogiri::HTML(raw_html) }
      .yield_self { |html| html.search('#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_ctl03_rightCol').any? }
  end
end
