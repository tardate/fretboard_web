$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '.', 'lib')
require 'sinatra'
require 'build_response'

set :public_folder, File.dirname(__FILE__) + '/'

get '/' do
  File.read('index.html')
end

get '/status.csv' do
  content_type 'text/csv'
  BuildResponse.get_instance(ci_server_url, ci_server_type).response
end

def ci_server_url
  ENV['FB_CI_SERVER_URL']
end

def ci_server_type
  ENV['FB_CI_SERVER_TYPE']
end
