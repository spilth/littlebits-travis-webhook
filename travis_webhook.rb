require 'sinatra'
require 'json'
require 'dotenv'
require 'digest/sha2'
require 'little_bits'

Dotenv.load

class TravisWebhook < Sinatra::Base
  set :travis_token, ENV['TRAVIS_USER_TOKEN']
  set :cloudbit_token, ENV['CLOUDBIT_ACCESS_TOKEN']
  set :cloudbit_id, ENV['CLOUDBIT_DEVICE_ID']

  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [ENV['BASIC_USERNAME'], ENV['BASIC_PASSWORD']]
    end
  end

  post '/' do
    if not valid_request?
      puts "Invalid payload request for repository #{repo_slug}"
    else
      payload = JSON.parse(params[:payload])

      if payload['status_message'] == 'Passed'
        success
      else
        failure
      end
    end
  end

  get '/failure' do
    protected!
    failure
  end

  get '/success' do
    protected!
    success
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

  def failure
    cloudbit.output(0, -1)
    'Failure'
  end

  def success
    cloudbit.output(100, -1)
    'Success'
  end

  def cloudbit
    LittleBits::CloudBit.new(settings.cloudbit_token, settings.cloudbit_id)
  end
end
