module PhoneHelper

  module Formatter

    def national
      return unless @original
      @national ||= plausible? ? phone.national : digits
    end

    def formatted
      return unless @original
      @formatted ||= plausible? ? phone.international : digits
    end
    alias international formatted

    def normalized
      @normalized ||= normalize if @original
    end

    def sanitized
      @sanitized ||= sanitize if @original
    end

    def prefix
      @prefix ||= phone.country_code if plausible?
    end

    def extension
      @extension ||= phone.extension if @original
    end

    private

    def normalize
      sanitized.gsub(/\A0+/, "")
    end

    def sanitize
      phone.sanitized
    end

    def digits
      @digits ||= @original.gsub(/\D/, "")
    end

  end

end
