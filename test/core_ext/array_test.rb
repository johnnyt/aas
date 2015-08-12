require_relative "../test_helper"
require "aas/core_ext/array"

class ArrayCoreExtTest < Minitest::Test
  def test_extract_options!
    assert_equal({}, [].extract_options!)
  end
end
