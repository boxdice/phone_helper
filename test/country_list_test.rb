require "test_helper"

class CountryListTest < Minitest::Test

  def test_loading_of_countries
    countries = PhoneHelper::CountryList.all
    assert_kind_of Array, countries
    country_codes = countries.map(&:alpha2)

    missing = Phonelib.phone_data.keys - country_codes
    assert_equal ["001"], missing # 001 - International Premium Rate Service

    obsolete = country_codes - Phonelib.phone_data.keys
    assert_equal [], obsolete
  end

  def test_finding_by_alpha2
    PhoneHelper::CountryList.all.each do |country|
      assert_equal [country], PhoneHelper::CountryList[country.alpha2]
    end
  end

  def test_finding_by_alpha3
    PhoneHelper::CountryList.all.each do |country|
      next unless country.alpha3
      assert_equal [country], PhoneHelper::CountryList[country.alpha3]
    end
  end

  def test_finding_by_name
    PhoneHelper::CountryList.all.each do |country|
      assert_equal [country], PhoneHelper::CountryList[country.name]
    end
  end

  def test_finding_by_calling_code
    PhoneHelper::CountryList.all.each do |country|
      country.calling_codes.each do |calling_code|
        assert_includes PhoneHelper::CountryList[calling_code], country
      end
    end
  end

end