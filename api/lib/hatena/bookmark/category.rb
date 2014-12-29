module Hatena
  class Bookmark
    module Category
      CATEGORIES = %w{general social economics life knowledge it fun entertainment game video picture}
      def self.to_query(category)
        case category
        when nil
          ['', { mode: 'rss' }]
        when ->(c) { CATEGORIES.include? c }
          ["/#{category}.rss", nil]
        else
          raise InvalidCategoryError.new "Valid categories are #{CATEGORIES.join(', ')}."
        end
      end
    end
  end
end
