require 'sinatra/base'
require 'ffaker'

class FakeCommentServer < Sinatra::Base
  get '/' do
    content_type 'text/javascript'
    "#{params['callback']}(#{JSON.dump(
      count: '10',
      bookmarks: 10.times.map { random_comment },
      eid: '100',
      title: FFaker::Lorem.word
    )})"
  end

  private

  def random_comment
    {
      timestamp: FFaker::Time.date.split(' ')[0],
      comment: FFaker::Lorem.phrase,
      user: FFaker::Lorem.word
    }
  end
end
