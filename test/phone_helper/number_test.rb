require "test_helper"

module PhoneHelper

  class NumberTest < Minitest::Test

    def test_should_handle_nil
      phone = PhoneHelper::Number.new(nil)
      assert_nil phone.normalized
      assert_nil phone.formatted
      assert_nil phone.search_index
    end

    def test_should_handle_valid_formatted_phone_number
      phone = PhoneHelper::Number.new("+4 219 031234 56")
      assert_equal "421903123456", phone.normalized
      assert_equal "+421 903 123456", phone.formatted
      assert_equal "903123456", phone.search_index
    end

    def test_should_handle_valid_national_phone_number_if_given_country
      phone = PhoneHelper::Number.new("09 03123-456", country: "Slovakia")
      assert_equal "421903123456", phone.normalized
      assert_equal "+421 903 123456", phone.formatted
      assert_equal "903123456", phone.search_index
    end

    def test_should_handle_valid_national_phone_number_if_given_calling_code
      phone = PhoneHelper::Number.new("09 0/3123 456", calling_code: "421")
      assert_equal "421903123456", phone.normalized
      assert_equal "+421 903 123456", phone.formatted
      assert_equal "903123456", phone.search_index
    end

    def test_should_handle_valid_national_phone_number_if_not_given_country_or_calling_code
      phone = PhoneHelper::Number.new("0 90312 3456")
      assert_equal "903123456", phone.normalized
      assert_equal "0903123456", phone.formatted
      assert_equal "903123456", phone.search_index
    end

    def test_should_handle_valid_national_phone_number_if_prefix_matches_country_calling_code
      phone = PhoneHelper::Number.new("0432123456")
      assert_equal "432123456", phone.normalized
      assert_equal "0432123456", phone.formatted
      assert_equal "432123456", phone.search_index
    end

    def test_should_handle_valid_national_phone_number_if_prefix_matches_country_calling_code_and_country_is_given
      phone = PhoneHelper::Number.new("0432123456", country: "Australia")
      assert_equal "61432123456", phone.normalized
      assert_equal "+61 432 123 456", phone.formatted
      assert_equal "432123456", phone.search_index
    end

    def test_should_not_add_leading_zero_if_not_present_in_original_number
      phone = PhoneHelper::Number.new("90312 3456")
      assert_equal "903123456", phone.normalized
      assert_equal "903123456", phone.formatted
      assert_equal "903123456", phone.search_index
    end

    def test_should_handle_formatted_number
      phone = PhoneHelper::Number.new("+421 (2) 1234 5678")
      assert_equal "421212345678", phone.normalized
      assert_equal "+421 2 12345678", phone.formatted
      assert_equal "212345678", phone.search_index
    end

    def test_should_handle_number_with_0_inside_brackets
      phone = PhoneHelper::Number.new("+421 (02) 1234 5678")
      assert_equal "421212345678", phone.normalized
      assert_equal "+421 2 12345678", phone.formatted
      assert_equal "212345678", phone.search_index
    end

    def test_should_handle_number_with_too_many_zeroes
      phone = PhoneHelper::Number.new("0006431234567")
      assert_equal "6431234567", phone.normalized
      assert_equal "+64 3 123 4567", phone.formatted
      assert_equal "31234567", phone.search_index
    end

    def test_plausible_should_return_true_if_number_can_be_formatted
      assert_equal true, PhoneHelper::Number.new("421 9 031 23456").plausible?
      assert_equal true, PhoneHelper::Number.new("09 03123-456", country: "Slovakia").plausible?
      assert_equal true, PhoneHelper::Number.new("090312345/6", calling_code: "421").plausible?
      assert_equal false, PhoneHelper::Number.new("09 03123-456").plausible?
    end

    def test_split_should_return_array_of_calling_code_and_number
      number = PhoneHelper::Number.new("421 9 031 23456")
      expected = %w(421 903123456)
      actual = number.split
      assert_equal expected, actual
    end

  end

end
