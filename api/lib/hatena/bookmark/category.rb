module Hatena
  class Bookmark
    class Category
      CATEGORIES = {
        all: '総合',
        social: '世の中',
        economics: '政治と経済',
        life: '暮らし',
        knowledge: '学び',
        it: 'テクノロジー',
        fun: 'おもしろ',
        entertainment: 'エンタメ',
        game: 'アニメとゲーム',
      }

      attr_accessor :id, :name

      def initialize(id:, name:)
        @id = id
        @name = name
      end

      def self.all
        CATEGORIES.map {|id,name| new(id: id, name: name) }
      end

      def to_query
        case id
        when :all
          ['', { mode: 'rss' }]
        when ->(c) { CATEGORIES[c] }
          ["/#{id}.rss", nil]
        else
          raise InvalidCategoryError.new "Valid categories are #{CATEGORIES.join(', ')}."
        end
      end
    end
  end
end
