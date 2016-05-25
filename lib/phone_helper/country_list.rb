require "csv"

require_relative "country"

module PhoneHelper

  module CountryList

    module_function

    def [](key)
      to_hash[key.downcase] if key
    end

    def guess_country(number)
      number = number.to_s
      until number.empty?
        if (countries = to_hash[number])
          country = countries.first if countries.length == 1
          country ||= countries.detect(&:main_country_for_code)
          return country && country.alpha2
        end
        number = number[0..-2]
      end
      nil
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
            hash[key] ||= []
            hash[key] << country
          end
        end
        hash
      end
    end

  end

end
