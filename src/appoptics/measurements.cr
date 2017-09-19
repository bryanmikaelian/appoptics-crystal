module Appoptics
  class Measurements
    PATH = "/v1/measurements"

    # Generates a one off metric
    def self.add(name: String, value: Number, tags: Hash)
      Appoptics::Client.submit PATH, { name: name, value: value, tags: tags }
    end
  end
end
