require_relative "test_helper"

class RepoTest < Minitest::Test
  class TestModel
    include Aas::Model
    attr_accessor :name
  end

  class TestModelRepo
    include Aas::Repo

    def initialize
      @store = Aas::MemoryStore.new
    end
  end

  attr_reader :repo

  def setup
    @repo = TestModelRepo.new
  end

  def test_create_adds_id_to_model
    model = TestModel.new
    repo.create model
    refute_nil model.id
  end
end
