module PhoneHelper

  class Country

    attr_reader :alpha2, :alpha3, :name, :calling_code

    def initialize(alpha2, alpha3, name, calling_code)
      @alpha2 = alpha2
      @alpha3 = alpha3
      @name = name
      @calling_code = calling_code
      @keys = [alpha2, alpha3, name, calling_code].map(&:downcase)
    end

    def match?(key)
      @keys.include?(key.to_s.downcase)
    end

  end

end
