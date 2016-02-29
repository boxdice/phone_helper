require "phony"

module PhoneHelper

  class Number

    def initialize(value, calling_code: nil, country: nil)
      @value = value
      @calling_code = calling_code
      @calling_code ||= if country
        countries = CountryList[country]
        countries.first.calling_code if countries.size == 1
      end
    end

    def plausible?
      return unless @value
      Phony.plausible?(normalized)
    end

    def normalized
      return unless @value
      @normalized ||= normalize
    end

    def formatted(format = :international)
      return unless @value
      @formatted ||= if plausible?
        Phony.format(normalized, format: format)
      else
        "0#{normalized}"
      end
    end

    def search_index
      return unless @value
      @search_index ||= if plausible?
        Phony.format(normalized, format: :national).gsub(/\A0+/, "").gsub(/\D/, "")
      else
        normalized
      end
    end

    def split
      return unless @value
      if plausible?
        parts = Phony.split(normalized)
        calling_code = parts.shift
        [calling_code, parts.join]
      else
        [nil, "0#{normalized}"]
      end
    end

    private

    def normalize
      result = @value.gsub(/\(0*(\d*)\)/, "\\1").gsub(/\D/, "")
      return Phony.normalize(result) if Phony.plausible?(result)

      result = result.gsub(/\A[0+]/, "")
      return result unless @calling_code

      result = "#{@calling_code}#{result}"
      return Phony.normalize(result) if Phony.plausible?(result)

      result
    end

  end

end
