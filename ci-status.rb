require 'sinatra'
require 'json'
require 'dotenv'
require './cloud_bit_client'

Dotenv.load

def red
  cloudbitClient.output(0)
  "Red"
end

def green
  cloudbitClient.output(100)
  "Green"
end

def cloudbitClient
  CloudBitClient.new(ENV['CLOUDBIT_ACCESS_TOKEN'], ENV['CLOUDBIT_DEVICE_ID'])
end

post '/' do
  payload = JSON.parse(params[:payload])

  if payload[:status_message] == 'Passed'
    green
  else
    red
  end
end

get '/red' do
  red
end

get '/green' do
  green
end


