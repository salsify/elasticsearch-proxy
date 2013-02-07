require 'rubygems'
require 'sinatra'
require 'sinatra/synchrony'
require 'faraday'

Faraday.default_adapter = :em_synchrony

@@bulk_mutex = Mutex.new

post '/*_bulk' do |path|
  content_type :json

  request.body.rewind

  conn = Faraday.new(url: 'http://localhost:9200')

  @@bulk_mutex.synchronize do
    response = conn.post do |req|
      req.url "#{path}_bulk"
      req.headers['Content-Type'] = 'application/json'
      req.body = request.body.read
    end
  end

  status response.status
  response.body
end

get '/*' do |path|
  conn = Faraday.new(url: 'http://localhost:9200')
  response = conn.get path
  status response.status
  response.body
end

