# typed: true
# frozen_string_literal: true

module MtgScraper::Card::ETL
  extend T::Sig
  extend MtgScraper::Procify
  extend self

  sig { params(set_name: String).returns(T::Array[Thread]) }
  def call(set_name)
    page_numbers(set_name).map do |page|
      Thread.new do
        set_html(set_name, page: page)
          .search('span.cardTitle a')
          .map { |node| extract_card_link(node) }
          .map(&MtgScraper::Card::Extract.to_proc >>
                MtgScraper::Card::Transform.to_proc >>
                MtgScraper::Card::Load.to_proc)
      end
    end
  end

  sig { params(node: Nokogiri::XML::Node).returns(URI::Generic) }
  def extract_card_link(node)
    Gatherer.build_path 'Pages', node['href'][3..-1], params: {}
  end

  sig { params(set_name: String).returns(T::Array[Integer]) }
  def page_numbers(set_name)
    set_html(set_name)
      .search('#ctl00_ctl00_ctl00_MainContent_SubContent_topPagingControlsContainer a')
      .map { |a| a.content.to_i - 1 }
  end

  sig { params(set_name: String, page: Integer).returns(Nokogiri::HTML::Document) }
  def set_html(set_name, page: 0)
    Gatherer
      .cards_url(set_name, page: page)
      .yield_self { |url| Net::HTTP.get(url) }
      .yield_self { |raw_html| Nokogiri::HTML(raw_html) }
  end
end
