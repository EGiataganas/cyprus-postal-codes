# frozen_string_literal: true

require "faraday"
require "faraday_middleware"

module CyprusPostalCodes
  class Client
    BASE_URL = "https://cypruspost.post/api/postal-codes/"

    attr_reader :api_key

    def initialize(api_key:)
      @api_key = api_key
    end

    def get(resource, options = {})
      @last_response = connection.get(resource, options) do |request|
        request.headers["Authorization"] = api_key
      end
      @last_response.body["data"]
    end

    def last_response
      @last_response if defined?(@last_response)
    end

    def inspect
      "#<CyprusPostalCodes::Client>"
    end

    private

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = BASE_URL
        conn.adapter Faraday.default_adapter
        conn.request :json
        conn.response :json, content_type: "application/json"
      end
    end
  end
end
