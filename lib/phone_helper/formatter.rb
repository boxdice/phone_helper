module PhoneHelper

  module Formatter

    def national
      return unless @original
      @national ||= phone.national
    end

    def formatted
      return unless @original
      @formatted ||= phone.international
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

  end

end
