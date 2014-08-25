module Hexlet
  class BaseClient
    def initialize(key, options={})
      @key = key
      @host = options[:host] || "http::/hexlet.io"
      @logger = options[:logger]
    end

    def login
      url = 'http://hexlet.io/api_member/user/check_auth.json'
      @logger.debug url

      RestClient.get url, {"X-Hexlet-Api-Key" => @key} do |response, request, result, &block|
      @logger.debug response
      200 == response.code
      end
    end
  end
end
