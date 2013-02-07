require 'rubygems'
require 'sinatra'
require 'net/http'

post '/*_bulk' do |path|
  content_type :json

  request.body.rewind

  net = Net::HTTP.new('localhost', 9200)
  req = Net::HTTP::Post.new("#{path}_bulk")

  response = net.start do |http|
    http.request(req, request.body.read)
  end

  status response.code
  response.body
end
