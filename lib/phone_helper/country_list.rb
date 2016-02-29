require "csv"

require_relative "country"

module PhoneHelper

  module CountryList

    module_function

    def [](key)
      all.select { |country| country.match?(key) }
    end

    def all
      @all ||= begin
        path = File.expand_path("../../../data/countries.csv", __FILE__)
        csv = File.read(path)
        CSV.parse(csv).map do |row|
          Country.new(*row)
        end
      end
    end

  end

end
