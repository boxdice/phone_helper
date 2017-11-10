require "phonelib"

module PhoneHelper

  class Number

    include PhoneHelper::Formatter

    def initialize(original, options = {})
      @original     = original
      @calling_code = options[:calling_code]
      @country      = options[:country]
      @postcode     = options[:postcode]
    end

    def plausible?
      phone.valid? if @original
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

    def types
      return [] unless @original
      phone.types
    end

    def calling_code
      @calling_code ||= CountryList.calling_code_for(@country)
    end

    def country_code
      @country_code ||= CountryList.country_code_for(@country)
    end

    private

    def phone
      @phone ||= build_phone
    end

    def build_phone
      return unless @original
      number = @original.gsub(/\A(\+|0{2,})/, "+")
      try_phone_with_fixed_line_prefix(number) ||
        try_phone_with_calling_code(number) ||
        build_phone_from_number(number)
    end

    def try_phone_with_fixed_line_prefix(number)
      return if number =~ /\A0[^0]/
      return unless calling_code && fixed_line_prefix
      number2 = [calling_code, fixed_line_prefix, number].join
      phone2 = build_phone_from_number(number2)
      phone2 if phone2.valid?
    end

    def try_phone_with_calling_code(number)
      return unless calling_code
      number2 = ["+#{calling_code}", number.gsub(/\A0+/, "")].join
      phone2 = build_phone_from_number(number2)
      phone2 if phone2.valid?
    end

    def build_phone_from_number(number)
      p = Phonelib::Phone.new("+#{number}")
      return p if p.valid?
      p = Phonelib::Phone.new(number)
      return p if p.valid?
      Phonelib::Phone.new(number, country_code)
    end

    def fixed_line_prefix
      return nil unless @country == "Australia" && @postcode
      @fixed_line_prefix ||= fixed_line_prefix_australia
    end

    def fixed_line_prefix_australia
      case @postcode.to_s
      when "0200", /^[12]/ then "2"
      when /^[056]/ then "8"
      when /^[49]/ then "7"
      when /^[378]/ then "3"
      end
    end

  end

end
