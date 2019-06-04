# frozen_string_literal: true

module MtgScraper::Card::Extract
  module_function

  def call(link, css_modifier: '')
    puts link
    html = Nokogiri::HTML(Net::HTTP.get(link))

    multiverse_id = CGI.parse(link.query)['multiverseid'].first

    extractors(css_modifier).reduce(multiverse_id: multiverse_id) do |acc, (key, extractor)|
      acc.merge(key => extractor.call(html))
    end
  rescue StandardError => e
    puts link
    puts e.message
    raise
  end

  def extractors(css_modifier)
    prefix = "ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_#{css_modifier}"

    {
      name: -> (html) { html.search("##{prefix}_nameRow div.value").text.strip },
      text: -> (html) { html.search("##{prefix}_textRow div.value div.cardtextbox").map(&:content).map(&:strip).join("\n") },
      mana_cost: -> (html) { html.search("##{prefix}_manaRow div.value img").map { |img| img.attr("alt") } },
      converted_mana_cost: -> (html) { html.search("##{prefix}_cmcRow div.value").first&.content&.strip },
      types: -> (html) { html.search(p "##{prefix}_typeRow div.value").first.content.strip },
      power_and_toughness: -> (html) { html.search("##{prefix}_ptRow div.value").children.text.strip },
      set: -> (html) { html.search("##{prefix}_currentSetSymbol a").last.content.strip },
      rarity: -> (html) { html.search("##{prefix}_rarityRow div.value span").first.content.strip },
      number: -> (html) { html.search("##{prefix}_numberRow div.value").first&.content&.strip },
      artist: -> (html) { html.search("##{prefix}_artistRow div.value a").text.strip },
      image_url: -> (html) { html.search("##{prefix}_cardImage").first.attr("src") },
    }
  end

  def to_proc
    method(:call).to_proc
  end
end
