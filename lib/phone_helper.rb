require_relative "phone_helper/version"

require_relative "phone_helper/country_list"
require_relative "phone_helper/number"

module PhoneHelper

  module_function

  def plausible?(value, country: nil, calling_code: nil)
    Number.new(value, country: country, calling_code: calling_code).plausible?
  end

  def normalize(value, country: nil, calling_code: nil)
    Number.new(value, country: country, calling_code: calling_code).normalized
  end

  def format(value, country: nil, calling_code: nil)
    Number.new(value, country: country, calling_code: calling_code).formatted
  end

  def search_index(value, country: nil, calling_code: nil)
    Number.new(value, country: country, calling_code: calling_code).search_index
  end

  def split(value, country: nil, calling_code: nil)
    Number.new(value, country: country, calling_code: calling_code).split
  end

end
