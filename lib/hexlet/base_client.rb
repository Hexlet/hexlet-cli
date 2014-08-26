module Hexlet
  class BaseClient
    def initialize(key, options={})
      @key = key
      @host = options[:host] || "http://hexlet.io"
      @logger = options[:logger]
      @router = Router.new @host
    end

    def login
      url = @router.api_member_user_check_url
      @logger.debug url

      RestClient.get url, headers do |response, request, result, &block|
        @logger.debug response
        200 == response.code
      end
    end

    private

    def headers(other = {})
      {"X-Hexlet-Api-Key" => @key}.merge other
    end
  end
end
