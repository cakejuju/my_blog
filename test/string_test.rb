require_relative './test_helper'
require_relative '../helpers/string_extension'
class StringTest < TestBasic

  def setup
    super
    @methods_names = %w[ marked two_slashN ]
    @class_name = String
  end

  # replace  "\n" to "\n\n"
  def test_two_slashN
    assert mocked_obj.two_slashN == "\n\n mocked object \n\n"
  end

  def mocked_obj
    "\n mocked object \n"
  end
end