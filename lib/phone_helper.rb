require_relative "phone_helper/version"

require_relative "phone_helper/country_list"
require_relative "phone_helper/number"

module PhoneHelper

  module_function

  def plausible?(value, country: nil, calling_code: nil, postcode: nil)
    Number.new(value, country: country, calling_code: calling_code, postcode: postcode).plausible?
  end

  def normalize(value, country: nil, calling_code: nil, postcode: nil)
    Number.new(value, country: country, calling_code: calling_code, postcode: postcode).normalized
  end

  def format(value, country: nil, calling_code: nil, postcode: nil)
    Number.new(value, country: country, calling_code: calling_code, postcode: postcode).formatted
  end

  def search_index(value, country: nil, calling_code: nil, postcode: nil)
    Number.new(value, country: country, calling_code: calling_code, postcode: postcode).search_index
  end

end
