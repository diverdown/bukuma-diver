require 'sinatra/base'
require 'nokogiri'
require 'ffaker'
class FakeHatenaBookmark < Sinatra::Base
  TOTAL_BOOKMARK_COUNT = 100
  %w{/hotentry* /entrylist /search/text}.each do |path|
    get path do
      content_type :xml
      fake_items
    end
  end

  post '/xmlrpc' do
    content_type :xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root {
        xml.value {
          xml.int TOTAL_BOOKMARK_COUNT
        }
      }
    end
    builder.to_xml
  end

  private

  def fake_items
    Nokogiri::XML::Builder.new { |xml|
      xml.root('xmlns:hatena' => 'foo') {
        20.times.each do
          xml.item {
            xml.title FFaker::Lorem.phrase
            xml.link FFaker::Internet.http_url
            xml['hatena'].bookmarkcount 10
          }
        end
      }
    }.to_xml
  end
end
