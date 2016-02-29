require "test_helper"

class PhoneHelperTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::PhoneHelper::VERSION
  end

  VALUES = ["0123 456 789", "421 903 123456", "421 (0903) 123 456"].freeze

  def test_plausible
    VALUES.each do |value|
      expected = ::PhoneHelper::Number.new(value, country: nil, calling_code: nil).plausible?
      actual = ::PhoneHelper.plausible?(value, country: nil, calling_code: nil)
      assert_equal expected, actual
    end
  end

  def test_normalize
    VALUES.each do |value|
      expected = ::PhoneHelper::Number.new(value, country: nil, calling_code: nil).normalized
      actual = ::PhoneHelper.normalize(value, country: nil, calling_code: nil)
      assert_equal expected, actual
    end
  end

  def test_format
    VALUES.each do |value|
      expected = ::PhoneHelper::Number.new(value, country: nil, calling_code: nil).formatted
      actual = ::PhoneHelper.format(value, country: nil, calling_code: nil)
      assert_equal expected, actual
    end
  end

  def test_search_index
    VALUES.each do |value|
      expected = ::PhoneHelper::Number.new(value, country: nil, calling_code: nil).search_index
      actual = ::PhoneHelper.search_index(value, country: nil, calling_code: nil)
      assert_equal expected, actual
    end
  end

  def test_split
    expected = PhoneHelper::Number.new("421 9 031 23456").split
    actual = PhoneHelper.split("421 9 031 23456")
    assert_equal expected, actual
  end

end
