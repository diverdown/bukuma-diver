module Faraday
  class HttpCache
    class DevelopmentLogger
      def debug(line)
        puts "\e[32m#{line}\e[0m"
      end
    end
  end
end
