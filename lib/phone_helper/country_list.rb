require "csv"

require_relative "country"

module PhoneHelper

  module CountryList

    module_function

    def [](key)
      all.detect { |country| country.match?(key) }
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

  end

end
