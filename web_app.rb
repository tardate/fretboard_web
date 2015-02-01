$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '.', 'lib')
require 'sinatra'
require 'active_support'
require 'active_support/core_ext/hash/conversions'
require 'nokogiri'
require 'uri'
require 'open-uri'
require 'build_response'

set :public_folder, File.dirname(__FILE__) + '/'

get '/' do
  File.read('index.html')
end

get '/status.csv' do
  content_type 'text/csv'
  BuildResponse.new(proxy_url).response
end

def proxy_url
  ENV['FB_PROXY_URL']
end
