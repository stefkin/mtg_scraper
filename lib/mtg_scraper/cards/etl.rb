# frozen_string_literal: true

module MtgScraper::Cards::ETL
  module_function

  def call(set_name)
    url = p Gatherer.cards_url(set_name, page: 0)

    Net::HTTP
      .get(url)
      .yield_self { |raw_html| Nokogiri::HTML(raw_html) }
      .search('span.cardTitle a')
      .map { |node| extract_card_link(node) }
      .map(&MtgScraper::Card::Extract.to_proc >>
            MtgScraper::Card::Transform.to_proc >>
            MtgScraper::Card::Load.to_proc)
  end

  def extract_card_link(node)
    Gatherer.build_path 'Pages', node['href'][3..-1], {}
  end

  def to_proc
    method(:call).to_proc
  end
end
