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
      phone.valid?
    end

    def normalized
      return unless @original
      @normalized ||= normalize
    end

    def sanitized
      return unless @original
      @sanitized ||= sanitize
    end

    def formatted
      return unless @original
      @formatted ||= if plausible?
        phone.international
      else
        @original.gsub(/\D/, "")
      end
    end

    def search_index
      return unless @original
      @search_index ||= if plausible?
        if calling_code || @original =~ /\A(00|\+)/
          phone.national.gsub(/\A0+/, "").gsub(/\D/, "")
        else
          @original.gsub(/\A0+/, "").gsub(/\D/, "")
        end
      else
        normalized
      end
    end

    def calling_code
      @calling_code ||= if @country
        countries = CountryList[@country]
        calling_codes = countries.first.calling_codes if countries && countries.size == 1
        countries.first.calling_codes.first if calling_codes && calling_codes.size == 1
      end
    end

    def country_code
      @country_code ||= if @country
        countries = CountryList[@country]
        countries.first.alpha2 if countries && countries.size == 1
      end
    end

    private

    def normalize
      sanitized.gsub(/\A0+/, "")
    end

    def sanitize
      phone.sanitized
    end

    def phone
      @phone ||= build_phone
    end

    def build_phone
      number = @original.gsub(/\(0*(\d*)\)/, "\\1").gsub(/\A(\+|0{2,})/, "+").scan(/(\A\+|\d)/).join
      if calling_code
        number2 = [calling_code, number.gsub(/\A0+/, "")].join
        phone2 = build_phone_from_number(number2)
        return phone2 if phone2.valid?
      end
      build_phone_from_number(number)
    end

    def build_phone_from_number(number)
      digits = number.scan(/\d+/).join
      Phonelib::Phone.new(number, country_code || CountryList.guess_country(digits))
    end

    def digits
      @digits ||= @original.scan(/\d+/).join
    end

  end

end
