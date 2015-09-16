require_relative "test_helper"

class ModelTest < Minitest::Test
  class TestModel
    include Aas::Model
    attr_accessor :name
  end

  def test_models_can_be_initialized_with_a_hash
    model = TestModel.new name: 'foo'
    assert_equal 'foo', model.name
  end

  def test_touch_sets_created_at_first_time_only
    model = TestModel.new
    assert model.created_at.nil?

    model.touch
    refute model.created_at.nil?

    first_created_at = model.created_at.dup
    model.touch
    assert_equal first_created_at, model.created_at
  end

  def test_touch_updates_updated_at
    model = TestModel.new
    assert model.updated_at.nil?

    model.touch
    refute model.updated_at.nil?

    first_updated_at = model.updated_at.dup
    model.touch
    refute_equal first_updated_at, model.updated_at
  end

  def test_default_version
    model = TestModel.new
    assert model.version.zero?
  end

  def test_is_new_record_when_id_is_nil
    model = TestModel.new
    assert model.new_record?

    model.id = 5
    refute model.new_record?
  end

  def test_implements_double_equals
    m1 = TestModel.new(id: 1)
    m2 = TestModel.new(id: 2)
    m3 = TestModel.new(id: 1)

    assert (m1 == m1)
    assert (m1 == m3)
    refute (m1 == m2)
  end
end
