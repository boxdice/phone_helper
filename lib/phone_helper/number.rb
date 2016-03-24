require "phony"

module PhoneHelper

  class Number

    def initialize(value, calling_code: nil, country: nil)
      @value = value.gsub(/\s/, "") if value
      @calling_code = calling_code
      @country = country
    end

    def plausible?
      return unless @value
      Phony.plausible?(normalized)
    end

    def normalized
      return unless @value
      @normalized ||= normalize
    end

    def formatted
      return unless @value
      @formatted ||= if plausible?
        if calling_code || @value =~ /\A(00|\+)/
          Phony.format(normalized, format: :international)
        else
          @value
        end
      else
        @value.gsub(/\D/, "")
      end
    end

    def search_index
      return unless @value
      @search_index ||= if plausible?
        if calling_code || @value =~ /\A(00|\+)/
          Phony.format(normalized, format: :national).gsub(/\A0+/, "").gsub(/\D/, "")
        else
          @value.gsub(/\A0+/, "").gsub(/\D/, "")
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

    def normalize
      result = @value.gsub(/\(0*(\d*)\)/, "\\1")
      return Phony.normalize(result) if result =~ /\A(\+|\A0{2,})/ && Phony.plausible?(result)

      result = result.gsub(/\A0+/, "").gsub(/\D/, "")
      return result unless calling_code

      with_country_calling_code = [calling_code, result].join
      return Phony.normalize(with_country_calling_code) if Phony.plausible?(with_country_calling_code)

      result
    end

  end

end
