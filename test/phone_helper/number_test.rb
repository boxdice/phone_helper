require "test_helper"

module PhoneHelper

  class NumberTest < Minitest::Test

    def test_calling_code
      assert_nil PhoneHelper::Number.new(nil).calling_code
      assert_nil PhoneHelper::Number.new("999123123").calling_code
      assert_nil PhoneHelper::Number.new("999123123", country: "Invalid Country").calling_code
      assert_equal "421", PhoneHelper::Number.new("999123123", country: "Slovakia").calling_code
      assert_equal "61", PhoneHelper::Number.new("999123123", country: "Australia").calling_code
    end

    def test_country_code
      assert_nil PhoneHelper::Number.new(nil).country_code
      assert_nil PhoneHelper::Number.new("999123123").country_code
      assert_nil PhoneHelper::Number.new("999123123", country: "Invalid Country").country_code
      assert_equal "SK", PhoneHelper::Number.new("999123123", country: "Slovakia").country_code
      assert_equal "AU", PhoneHelper::Number.new("999123123", country: "Australia").country_code
    end

    def test_sanitized
      assert_nil PhoneHelper::Number.new(nil).sanitized
      assert_equal "421903123456", PhoneHelper::Number.new("+4 219 031234 56").sanitized
      assert_equal "421903123456", PhoneHelper::Number.new("09 03123-456", country: "Slovakia").sanitized
      assert_equal "123456", PhoneHelper::Number.new("123456", country: "Slovakia").sanitized
      assert_equal "421903123456", PhoneHelper::Number.new("09 0/3123 456", calling_code: "421").sanitized
      assert_equal "0903123456", PhoneHelper::Number.new("0 90312 3456").sanitized
      assert_equal "0432123456", PhoneHelper::Number.new("0432123456").sanitized
      assert_equal "61432123456", PhoneHelper::Number.new("0432123456", country: "Australia").sanitized
      assert_equal "903123456", PhoneHelper::Number.new("90312 3456").sanitized
      assert_equal "421212345678", PhoneHelper::Number.new("+421 (2) 1234 5678").sanitized
      assert_equal "421212345678", PhoneHelper::Number.new("+421 (02) 1234 5678").sanitized
      assert_equal "64212345678", PhoneHelper::Number.new("00064212345678").sanitized
    end

    def test_normalized
      assert_nil PhoneHelper::Number.new(nil).normalized
      assert_equal "421903123456", PhoneHelper::Number.new("+4 219 031234 56").normalized
      assert_equal "421903123456", PhoneHelper::Number.new("09 03123-456", country: "Slovakia").normalized
      assert_equal "123456", PhoneHelper::Number.new("123456", country: "Slovakia").normalized
      assert_equal "421903123456", PhoneHelper::Number.new("09 0/3123 456", calling_code: "421").normalized
      assert_equal "903123456", PhoneHelper::Number.new("0 90312 3456").normalized
      assert_equal "432123456", PhoneHelper::Number.new("0432123456").normalized
      assert_equal "61432123456", PhoneHelper::Number.new("0432123456", country: "Australia").normalized
      assert_equal "903123456", PhoneHelper::Number.new("90312 3456").normalized
      assert_equal "421212345678", PhoneHelper::Number.new("+421 (2) 1234 5678").normalized
      assert_equal "421212345678", PhoneHelper::Number.new("+421 (02) 1234 5678").normalized
      assert_equal "64212345678", PhoneHelper::Number.new("00064212345678").normalized
    end

    def test_formatted
      assert_nil PhoneHelper::Number.new(nil).formatted
      assert_equal "+421 903 123 456", PhoneHelper::Number.new("+4 219 031234 56").formatted
      assert_equal "+421 903 123 456", PhoneHelper::Number.new("09 03123-456", country: "Slovakia").formatted
      assert_equal "123456", PhoneHelper::Number.new("123456", country: "Slovakia").formatted
      assert_equal "23456789", PhoneHelper::Number.new("23456789").formatted
      assert_equal "+421 2/345 678 90", PhoneHelper::Number.new("234567890", country: "Slovakia").formatted
      assert_equal "+421 2/345 678 90", PhoneHelper::Number.new("0234567890", country: "Slovakia").formatted
      assert_equal "+421 903 123 456", PhoneHelper::Number.new("09 0/3123 456", calling_code: "421").formatted
      assert_equal "+421 2/623 456 78", PhoneHelper::Number.new("+421 (2) 6234 5678").formatted
      assert_equal "+421 2/623 456 78", PhoneHelper::Number.new("+421 (02) 6234 5678").formatted
      assert_equal "+64 21 234 5678", PhoneHelper::Number.new("00064212345678").formatted
      assert_equal "+81 44-411-1444", PhoneHelper::Number.new("81444111444").formatted
      assert_equal "+81 44-411-1444", PhoneHelper::Number.new("81444111444", country: "Australia").formatted
      assert_equal "0498574619", PhoneHelper::Number.new("0498574619").formatted

      skip # https://github.com/daddyz/phonelib/issues/72
      assert_equal "49123456", PhoneHelper::Number.new("49123456").formatted
    end

    def test_search_index
      assert_nil PhoneHelper::Number.new(nil).search_index
      assert_equal "903123456", PhoneHelper::Number.new("+4 219 031234 56").search_index
      assert_equal "903123456", PhoneHelper::Number.new("09 03123-456", country: "Slovakia").search_index
      assert_equal "123456", PhoneHelper::Number.new("123456", country: "Slovakia").search_index
      assert_equal "903123456", PhoneHelper::Number.new("09 0/3123 456", calling_code: "421").search_index
      assert_equal "903123456", PhoneHelper::Number.new("0 90312 3456").search_index
      assert_equal "432123456", PhoneHelper::Number.new("0432123456").search_index
      assert_equal "432123456", PhoneHelper::Number.new("0432123456", country: "Australia").search_index
      assert_equal "903123456", PhoneHelper::Number.new("90312 3456").search_index
      assert_equal "262345678", PhoneHelper::Number.new("+421 (2) 6234 5678").search_index
      assert_equal "262345678", PhoneHelper::Number.new("+421 (02) 6234 5678").search_index
      assert_equal "212345678", PhoneHelper::Number.new("00064212345678").search_index
    end

    def test_guess_australian_landline_from_postcode
      assert_equal "+61 2 4954 2477", PhoneHelper::Number.new("49542477", country: "Australia", postcode: "2281").formatted
      assert_equal "+61 2 4954 2477", PhoneHelper::Number.new("0249542477", country: "Australia", postcode: "2281").formatted
      assert_equal "+61 2 4954 2477", PhoneHelper::Number.new("0249542477", country: "Australia", postcode: "3206").formatted
      assert_equal "+61 3 4954 2477", PhoneHelper::Number.new("49542477", country: "Australia", postcode: "3206").formatted
      assert_equal "+49 4954 2477", PhoneHelper::Number.new("49542477", country: "Germany", postcode: "3206").formatted
      assert_equal "+49 5424 77", PhoneHelper::Number.new("49542477", country: "Japan", postcode: "3206").formatted
    end

  end

end
