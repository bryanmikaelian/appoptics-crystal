module AppOptics
  class Measurements
    PATH = "/measurements"

    # Generates a one off metric
    def self.measure(name, value : Number, tags : Hash = Hash(String, String).new)
      AppOptics::Client.submit PATH, payload: { "measurements" => [{ "name" => name, "value" => value, "tags" => tags }] }
    end
  end
end
