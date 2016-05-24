require "csv"

require_relative "country"

module PhoneHelper

  module CountryList

    module_function

    def [](key)
      to_hash[key.downcase] if key
    end

    def all
      @all ||= begin
        path = File.expand_path("../../../data/countries.csv", __FILE__)
        csv = File.read(path)
        CSV.parse(csv).map do |alpha2, alpha3, name|
          Country.new(alpha2, alpha3, name)
        end
      end
    end

    def to_hash
      @as_hash ||= begin
        hash = {}
        all.each do |country|
          country.keys.each do |key|
            hash[key] = country
          end
        end
        hash
      end
    end

  end

end
