require_relative "test_helper"

class MemoryStoreTest < Minitest::Test
  Person = Struct.new :name do
    attr_accessor :id
  end

  PersonNamed = Struct.new :name
  PersonFooBarBaz = Class.new

  class TestModelRepo
    include Aas::Repo

    def initialize
      @store = Aas::MemoryStore.new
    end

    def query_person_named klass, selector
      all(klass).select do |person|
        person.name == selector.name
      end
    end
  end

  attr_reader :repo

  def setup
    @repo = TestModelRepo.new
    repo.clear
    repo.initialize_storage
  end

  def test_crud_operations
    assert_equal 0, repo.count(Person), "Precondition: there should be no records"

    person = Person.new 'foo'
    repo.create person

    assert person.id, "repo must set the ID after creating"

    assert_equal 1, repo.count(Person)

    assert_equal person, repo.find(Person, person.id)

    assert_equal [person], repo.all(Person)

    person.name = 'bar'
    repo.update person
    assert_equal 'bar', repo.find(Person, person.id).name

    repo.delete(person)

    assert_equal 0, repo.count(Person)
  end

  def test_raises_error_when_no_reecord_exists
    assert_equal 0, repo.count(Person)

    assert_raises Aas::RecordNotFoundError do
      repo.find Person, 1
    end
  end

  def test_first_and_last
    assert_equal 0, repo.count(Person), "Precondition: there should be no records"

    foo = Person.new "foo"
    bar = Person.new "bar"

    repo.create foo
    repo.create bar

    assert_equal foo, repo.first(Person)
    assert_equal bar, repo.last(Person)
  end

  def test_clear_wipes_data
    assert_equal 0, repo.count(Person), "Precondition: there should be no records"

    foo = Person.new "foo"
    repo.create foo

    refute_empty repo.all(Person)
    assert_equal 1, repo.count(Person)
    assert repo.find(Person, foo.id)

    repo.clear

    assert_empty repo.all(Person)
    assert_equal 0, repo.count(Person)
  end

  def test_raises_an_error_when_query_not_implemented
    assert_raises Aas::QueryNotImplementedError do
      repo.query Person, PersonFooBarBaz.new
    end
  end

  def test_uses_query_method_to_implement_queries
    assert_equal 0, repo.count(Person), "Precondition: there should be no records"

    foo = Person.new "foo"
    bar = Person.new "bar"

    repo.create foo
    repo.create bar

    assert_equal 2, repo.count(Person)

    query = repo.query(Person, PersonNamed.new("foo"))
    refute_empty query
    assert_equal foo, query.first
  end
end
