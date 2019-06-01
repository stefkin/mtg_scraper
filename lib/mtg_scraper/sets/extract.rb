# frozen_string_literal: true

module MtgScraper
  module Sets
    module Extract
      module_function

      def call
        p Net::HTTP
          .get(Gatherer.sets_url)
          .yield_self { |raw_html| Nokogiri::HTML(raw_html) }
          .search('select#ctl00_ctl00_MainContent_Content_SearchControls_setAddText option')
          .map(&:content)
          .reject(&:empty?)
      end
    end
  end
end
