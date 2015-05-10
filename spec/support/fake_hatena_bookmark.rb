require 'sinatra/base'
require 'nokogiri'
require 'ffaker'
class FakeHatenaBookmark < Sinatra::Base
  %w{/hotentry* /entrylist /search/text}.each do |path|
    get path do
      content_type :xml
      fake_items
    end
  end

  post '/xmlrpc' do
    content_type :xml
    Nokogiri::XML::Builder.new do |xml|
      xml.root {
        xml.value {
          xml.int 100
        }
      }
    end
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
