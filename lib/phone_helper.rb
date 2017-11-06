require_relative "phone_helper/version"

require_relative "phone_helper/country_list"
require_relative "phone_helper/formatter"
require_relative "phone_helper/number"

module PhoneHelper

  module_function

  def plausible?(value, options = nil)
    Number.new(value, options).plausible?
  end

  def normalize(value, options = nil)
    Number.new(value, options).normalized
  end

  def format(value, options = nil)
    Number.new(value, options).formatted
  end

  def search_index(value, options = nil)
    Number.new(value, options).search_index
  end

  def international(value, options = {})
    Number.new(value, options).international
  end

  def national(value, options = {})
    Number.new(value, options).national
  end

  def country_code(country)
    CountryList.country_code_for(country)
  end

end
