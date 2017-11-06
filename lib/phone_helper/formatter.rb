module PhoneHelper

  module Formatter

    def national
      return unless @original
      @formatted ||= plausible? ? phone.national : digits
    end

    def formatted
      return unless @original
      @formatted ||= plausible? ? phone.international : digits
    end
    alias international formatted

    def normalized
      return unless @original
      @normalized ||= normalize
    end

    def sanitized
      return unless @original
      @sanitized ||= sanitize
    end

    def prefix
      return unless @original
      @prefix ||= phone.country_code if plausible?
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
