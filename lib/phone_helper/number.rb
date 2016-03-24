require "phonelib"

module PhoneHelper

  class Number

    def initialize(original, calling_code: nil, country: nil)
      @original = original
      @calling_code = calling_code
      @country = country
    end

    def plausible?
      return unless @original
      Phonelib.valid?(sanitized)
    end

    def normalized
      return unless @original
      @normalized ||= sanitized.gsub(/\A0+/, "")
    end

    def sanitized
      return unless @original
      @sanitized ||= sanitize
    end

    def formatted
      return unless @original
      @formatted ||= if plausible?
        if calling_code || @original =~ /\A(00|\+)/
          Phonelib.parse(normalized).international
        else
          @original
        end
      else
        @original.gsub(/\D/, "")
      end
    end

    def search_index
      return unless @original
      @search_index ||= if plausible?
        if calling_code || @original =~ /\A(00|\+)/
          Phonelib.parse(normalized).national.gsub(/\A0+/, "").gsub(/\D/, "")
        else
          @original.gsub(/\A0+/, "").gsub(/\D/, "")
        end
      else
        normalized
      end
    end

    private

    def calling_code
      @calling_code ||= if @country
        countries = CountryList[@country]
        countries.first.calling_code if countries.size == 1
      end
    end

    def sanitize
      result = @original.gsub(/\(0*(\d*)\)/, "\\1").gsub(/\A(\+|0{2,})/, "+").scan(/(\A\+|\d)/).join

      return Phonelib.parse(result).sanitized if Phonelib.valid?(result)

      return result unless calling_code

      with_country_calling_code = [calling_code, result.gsub(/\A0+/, "")].join
      return Phonelib.parse(with_country_calling_code).sanitized if Phonelib.valid?(with_country_calling_code)

      result
    end

  end

end
