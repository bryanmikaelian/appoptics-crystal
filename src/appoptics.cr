require "./appoptics/*"
require "http/client"
require "json"

module AppOptics
  class Client
    API_URL = URI.parse("https://my.appoptics.com")

    @@config = Config.new
    @@client = HTTP::Client.new(API_URL)

    def self.config
      @@config
    end

    def self.configure(&block)
      yield @@config
      @@client.basic_auth(@@config.email, @@config.key)
    end


    def self.submit(path, payload : Hash)
      if @@config.valid?
        global_tags = {"tags" => @@config.tags.merge({"host" => System.hostname })}
        payload = payload.merge(global_tags)

        headers = HTTP::Headers{"Content-Type" => "application/json", "User-Agent" => "appoptics-crystallang/1.0.0"}
        @@client.post("/metrics-api/v1/" + path, headers: headers, body: payload.to_json) do |response|
          if response.success?
            puts "Payload sent to Appoptics"
          end
        end
      else
        puts "Payload not submitted. Is your client properly configured?"
      end
    end
  end

  private class Config
    property :email, :key, :tags

    @email : String?
    @key : String?
    @tags = {} of String => String

    def valid?
      !!(@email && @key)
    end
  end
end

AppOptics::Client.configure do |config|
  config.email = ENV["APPOPTICS_EMAIL"]
  config.key = ENV["APPOPTICS_KEY"]
end


AppOptics::Measurements.measure("crystal.test", value: 2)
