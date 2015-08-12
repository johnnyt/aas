require_relative "../test_helper"
require "aas/core_ext/hash"

class HashCoreExtTest < Minitest::Test
  def test_symbolize
    assert_equal({ foo: "bar" }, { "foo" => "bar" }.symbolize)
  end
end
