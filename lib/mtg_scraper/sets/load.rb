# frozen_string_literal: true

module MtgScraper
  module Sets
    module Load
      module_function

      def call(set_names)
        set_names.each { |name| DB[:sets].insert(name: name) }
      end

      def to_proc
        method(:call).to_proc
      end
    end
  end
end
