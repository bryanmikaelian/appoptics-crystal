require "./appoptics/*"

module Appoptics
  class Client
    API_URL = "https://metrics-api.myappoptics.com"

    @@config = Config.new

    def self.configure(&block)
      yield @@config
    end

    def self.submit(path: String, payload: Hash)
      if @@config.valid?
        spawn do
          # TODO: Send to AO
        end
      else
        puts "Payload not submitted. Is your client properly configured?"
      end
    end
  end

  private class Config
    property :email, :key, :global_tags

    def valid?
      !!(@email && @key)
    end
  end
end
