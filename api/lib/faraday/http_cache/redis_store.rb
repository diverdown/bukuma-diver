module Faraday
  class HttpCache
    class RedisStore
      PREFIX = 'http_cache:'
      TTL = 3600

      def initialize(client)
        @client = client
      end

      def write(key, value)
        @client.set with_prefix(key), value
        @client.expire with_prefix(key), TTL
      end

      def read(key)
        @client.get with_prefix(key)
      end

      private

      def with_prefix(key)
        "#{PREFIX}#{key}"
      end
    end
  end
end
