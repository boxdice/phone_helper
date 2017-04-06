module PhoneHelper

  class Country

    attr_reader :alpha2, :alpha3, :name

    def initialize(alpha2, alpha3 = nil, name = nil)
      @alpha2 = alpha2 unless alpha2 && alpha2.empty?
      @alpha3 = alpha3 unless alpha3 && alpha3.empty?
      @name = name
    end

    def match?(key)
      keys.include?(key.to_s.downcase)
    end

    def main_country_for_code
      return unless data
      data[:main_country_for_code]
    end

    def country_code
      return unless data
      data[:country_code]
    end

    def leading_digits
      return unless data
      @leading_digits ||= unpack(data[:leading_digits])
    end

    def calling_codes
      return unless data
      @calling_codes ||=
        if leading_digits
          leading_digits.map do |digits|
            [country_code, digits].join
          end
        else
          [country_code]
        end
    end

    def keys
      @keys ||= [alpha2, alpha3, name, calling_codes].flatten.compact.map(&:downcase)
    end

    private

    def data
      Phonelib.phone_data[alpha2]
    end

    def unpack(leading_digits)
      case leading_digits
      when /\A(.*)\|(.*)\z/
        unpack(Regexp.last_match(1)) + unpack(Regexp.last_match(2))
      when /\A(.*)\[(.*)\](.*)\z/
        digits = Regexp.last_match(2).chars
        digits.map { |digit| "#{Regexp.last_match(1)}#{digit}#{Regexp.last_match(3)}" }
      when /./
        [leading_digits]
      end
    end

  end

end
