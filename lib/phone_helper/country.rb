module PhoneHelper

  class Country

    attr_reader :alpha2, :alpha3, :name

    def initialize(alpha2, alpha3, name)
      @alpha2 = alpha2
      @alpha3 = alpha3
      @name = name
    end

    def match?(key)
      keys.include?(key.to_s.downcase)
    end

    def main_country_for_code
      data && data[:main_country_for_code]
    end

    def calling_codes
      return unless data
      @calling_codes ||= begin
        country_code = data[:country_code]
        leading_digits = data[:leading_digits]
        unpack(country_code, leading_digits)
      end
    end

    private

    def keys
      @keys ||= [alpha2, alpha3, name, calling_code].flatten.compact.map(&:downcase)
    end

    def data
      Phonelib.phone_data[alpha2]
    end

    def unpack(country_code, leading_digits)
      case leading_digits
      when /\A(.*)\|(.*)\z/
        unpack(country_code, Regexp.last_match(1)) + unpack(country_code, Regexp.last_match(2))
      when /\A(.*)\[(.*)\](.*)\z/
        digits = Regexp.last_match(2).chars
        digits.map { |digit| "#{country_code} #{Regexp.last_match(1)}#{digit}#{Regexp.last_match(3)}" }
      when /./ then ["#{country_code} #{leading_digits}"]
      else [country_code]
      end
    end

  end

end
