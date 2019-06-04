# frozen_string_literal: true

module MtgScraper::Card::Extract
  module_function

  def call(link)
    puts link
    html = Nokogiri::HTML(Net::HTTP.get(link))

    multiverse_id = CGI.parse(link.query)['multiverseid'].first

    sections(html).map do |section|
      extractors.reduce(multiverse_id: multiverse_id) do |acc, (key, extractor)|
        acc.merge(key => extractor.call(section))
      end
    end
  end

  def sections(html)
    html.search("//div[contains(@id, 'componentWrapper')]")
  end

  def extractors
    {
      name: -> (html) { html.search(".//div[contains(@id, 'nameRow')]/div[@class='value']").text.strip },
      text: -> (html) { html.search(".//div[contains(@id, 'textRow')]/div[@class='value']/div[@class='cardtextbox']").map(&:content).map(&:strip).join("\n") },
      mana_cost: -> (html) { html.search(".//div[contains(@id, 'manaRow')]/div[@class='value']/img").map { |img| img.attr("alt") } },
      converted_mana_cost: -> (html) { html.search(".//div[contains(@id, 'cmcRow')]/div[@class='value']").first&.content&.strip },
      types: -> (html) { html.search(".//div[contains(@id, 'typeRow')]/div[@class='value']").first.content.strip },
      power_and_toughness: -> (html) { html.search(".//div[contains(@id, 'ptRow')]/div[@class='value']").children.text.strip },
      set: -> (html) { html.search(".//div[contains(@id, 'currentSetSymbol')]/a").last.content.strip },
      rarity: -> (html) { html.search(".//div[contains(@id, 'rarityRow')]/div[@class='value']/span").first.content.strip },
      number: -> (html) { html.search(".//div[contains(@id, 'numberRow')]/div[@class='value']").first&.content&.strip },
      artist: -> (html) { html.search(".//div[contains(@id, 'artistRow')]/div[@class='value']/a").text.strip },
      image_url: -> (html) { html.search(".//img[contains(@id, 'cardImage')]").first.attr("src") },
      flavor_text: -> (html) { html.search(".//div[contains(@id, 'FlavorText')]/div[@class='flavortextbox']").text.strip },
    }
  end

  def to_proc
    method(:call).to_proc
  end
end
