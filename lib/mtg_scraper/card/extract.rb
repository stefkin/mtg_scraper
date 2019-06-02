# frozen_string_literal: true

module MtgScraper::Card::Extract
  module_function

  EXTRACTORS = {
    name: -> (html) { html.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_nameRow div.value").text.strip },
    text: -> (html) { html.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_textRow div.value div.cardtextbox").map(&:content).map(&:strip).join("\n") },
    mana_cost: -> (html) { html.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_manaRow div.value img").map { |img| img.attr("alt") } },
    converted_mana_cost: -> (html) { html.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_cmcRow div.value").first&.content&.strip },
    types: -> (html) { html.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_typeRow div.value").first.content.strip },
    power_and_toughness: -> (html) { html.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_ptRow div.value").children.text.strip },
    set: -> (html) { html.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_currentSetSymbol a").last.content.strip },
    rarity: -> (html) { html.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_rarityRow div.value span").first.content.strip },
    number: -> (html) { html.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_numberRow div.value").first&.content&.strip },
    artist: -> (html) { html.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_artistRow div.value a").text.strip },
    image_url: -> (html) { html.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_cardImage").first.attr("src") },
  }.freeze

  def call(link)
    html = Nokogiri::HTML(Net::HTTP.get(p link))

    multiverse_id = CGI.parse(link.query)['multiverseid'].first

    EXTRACTORS.reduce(multiverse_id: multiverse_id) do |acc, (key, extractor)|
      acc.merge(key => extractor.call(html))
    end
  end

  def to_proc
    method(:call).to_proc
  end
end
