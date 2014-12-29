module Hatena
  class Bookmark
    module Category
      CATEGORIES = {
        general: '一般',
        social: '世の中',
        economics: '政治と経済',
        life: '暮らし',
        knowledge: '学び',
        it: 'テクノロジー',
        fun: 'おもしろ',
        entertainment: 'エンタメ',
        game: 'アニメとゲーム',
      }

      def self.all
        CATEGORIES
      end

      def self.to_query(category)
        case category
        when nil
          ['', { mode: 'rss' }]
        when ->(c) { CATEGORIES[c] }
          ["/#{category}.rss", nil]
        else
          raise InvalidCategoryError.new "Valid categories are #{CATEGORIES.join(', ')}."
        end
      end
    end
  end
end
