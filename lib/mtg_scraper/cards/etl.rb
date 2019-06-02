# frozen_string_literal: true

module MtgScraper::Cards::ETL
  module_function

  def call(set_name)
    page_numbers(set_name).flat_map do |page|
      set_html(set_name, page: page)
        .search('span.cardTitle a')
        .map { |node| extract_card_link(node) }
        .map(&MtgScraper::Card::Extract.to_proc >>
             MtgScraper::Card::Transform.to_proc >>
             MtgScraper::Card::Load.to_proc)
    end
  end

  def extract_card_link(node)
    Gatherer.build_path 'Pages', node['href'][3..-1], {}
  end

  def page_numbers(set_name)
    set_html(set_name)
      .search('#ctl00_ctl00_ctl00_MainContent_SubContent_topPagingControlsContainer a')
      .map { |a| a.content.to_i - 1 }
  end

  def set_html(set_name, page: 0)
    Gatherer.cards_url(set_name, page: page)
      .yield_self { |url| Net::HTTP.get(url) }
      .yield_self { |raw_html| Nokogiri::HTML(raw_html) }
  end

  def to_proc
    method(:call).to_proc
  end
end
