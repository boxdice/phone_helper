require "test_helper"

class CountryTest < Minitest::Test

  def test_match_method
    country = PhoneHelper::Country.new("YT", "MYT", "Mayotte")
    assert_equal true, country.match?("YT")
    assert_equal true, country.match?("yt")
    assert_equal true, country.match?("MYT")
    assert_equal true, country.match?("myt")
    assert_equal true, country.match?("Mayotte")
    assert_equal true, country.match?("mayotte")
    assert_equal true, country.match?("262")
    assert_equal true, country.match?("262269")
    assert_equal true, country.match?("26263")
  end

  def test_country_code_method
    assert_nil PhoneHelper::Country.new("XX").country_code
    assert_equal "61", PhoneHelper::Country.new("AU").country_code
    assert_equal "262", PhoneHelper::Country.new("YT").country_code
  end

  def test_leading_digits_method
    assert_nil PhoneHelper::Country.new("XX").leading_digits
    assert_nil PhoneHelper::Country.new("AU").leading_digits
    assert_equal %w[269 63], PhoneHelper::Country.new("YT").leading_digits
  end

  def test_calling_code_method
    assert_nil PhoneHelper::Country.new("XX").calling_code
    assert_equal "61", PhoneHelper::Country.new("AU").calling_code
    assert_equal "262", PhoneHelper::Country.new("YT").calling_code
  end

  def test_calling_codes_method
    assert_nil PhoneHelper::Country.new("XX").calling_codes
    assert_equal %w[61], PhoneHelper::Country.new("AU").calling_codes
    assert_equal %w[262269 26263], PhoneHelper::Country.new("YT").calling_codes
  end

  def test_keys_method
    assert_equal %w[xx], PhoneHelper::Country.new("XX").keys
    assert_equal %w[au aus australia 61], PhoneHelper::Country.new("AU", "AUS", "Australia").keys
    assert_equal %w[yt 262 262269 26263], PhoneHelper::Country.new("YT").keys
  end

end
