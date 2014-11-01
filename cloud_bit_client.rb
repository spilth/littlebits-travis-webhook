require 'rest_client'

class CloudBitClient
  def initialize(api_token, device_id)
    @api_token = api_token
    @device_id = device_id
  end

  def output(percent, duration = -1)
    RestClient.post "https://api-http.littlebitscloud.cc/devices/#{device_id}/output",
      {
        :percent => percent.to_s,
        :duration_ms => duration.to_s
      },
      Accept: "application/vnd.littlebits.v2+json",
      Authorization: "Bearer #{api_token}"
  end

  private

  attr_reader :api_token, :device_id
end
