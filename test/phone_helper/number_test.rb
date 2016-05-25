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
      assert_equal "+421 903 123 456", PhoneHelper::Number.new("09 0/3123 456", calling_code: "421").formatted
      assert_equal "+421 2/123 456 78", PhoneHelper::Number.new("+421 (2) 1234 5678").formatted
      assert_equal "+421 2/123 456 78", PhoneHelper::Number.new("+421 (02) 1234 5678").formatted
      assert_equal "+64 21 234 5678", PhoneHelper::Number.new("00064212345678").formatted
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
      assert_equal "212345678", PhoneHelper::Number.new("+421 (2) 1234 5678").search_index
      assert_equal "212345678", PhoneHelper::Number.new("+421 (02) 1234 5678").search_index
      assert_equal "212345678", PhoneHelper::Number.new("00064212345678").search_index
    end

  end

end
