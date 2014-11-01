require 'sinatra'
require 'json'
require 'dotenv'
require 'digest/sha2'
require './cloud_bit_client'

Dotenv.load

class TravisWebhook < Sinatra::Base
  set :travis_token, ENV['TRAVIS_USER_TOKEN']
  set :cloudbit_token, ENV['CLOUDBIT_ACCESS_TOKEN']
  set :cloudbit_id, ENV['CLOUDBIT_DEVICE_ID']

  post '/' do
    if not valid_request?
      puts "Invalid payload request for repository #{repo_slug}"
    else
      payload = JSON.parse(params[:payload])

      if payload["status_message"] == 'Passed'
        green
      else
        red
      end

    end
  end

  get '/red' do
    red
  end

  get '/green' do
    green
  end

  def valid_request?
    digest = Digest::SHA2.new.update("#{repo_slug}#{settings.travis_token}")
    digest.to_s == authorization
  end

  def authorization
    env['HTTP_AUTHORIZATION']
  end

  def repo_slug
    env['HTTP_TRAVIS_REPO_SLUG']
  end

  def red
    cloudbitClient.output(0)
    "Red"
  end

  def green
    cloudbitClient.output(100)
    "Green"
  end

  def cloudbitClient
    CloudBitClient.new(settings.cloudbit_token, settings.cloudbit_id)
  end
end
