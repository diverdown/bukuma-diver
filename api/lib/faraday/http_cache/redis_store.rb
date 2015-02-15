module Faraday
  class HttpCache
    class RedisStore
      PREFIX = 'http_cache:'
      TTL = 3600

      def initialize(client)
        @client = client
      end

      def write(key, value)
        @client.set with_prefix(key), Oj.dump(value)
        @client.expire with_prefix(key), TTL
      end

      def read(key)
        if cached = @client.get(with_prefix(key))
          Oj.load(cached)
        end
      end

      def delete(key)
        @client.del with_prefix(key)
      end

      private

      def with_prefix(key)
        "#{PREFIX}#{key}"
      end
    end
  end
end
