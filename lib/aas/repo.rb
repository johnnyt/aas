module Aas
  module Repo
    def create record
      record.id ||= next_id
      store.set record
    end

    def update record
      store.set record
    end

    def delete record
      store.delete record
    end

    def clear
      store.clear
    end

    def all klass
      store.all klass
    end

    def find klass, id
      store.get klass, id
    end

    def first klass
      all(klass).first
    end

    def last klass
      all(klass).last
    end

    def sample klass
      all(klass).sample
    end

    def empty? klass
      all(klass).empty?
    end

    def count klass
      all(klass).count
    end

    def query klass, selector
      if query_implemented? klass, selector
        send query_method(klass, selector), klass, selector
      else
        raise QueryNotImplementedError, selector
      end
    end

    def initialize_storage

    end

    private
    def store
      @store
    end

    def next_id
      @counter ||= 0
      @counter = @counter + 1
      @counter
    end

    def query_method klass, selector
      "query_#{selector_key selector}"
    end

    def query_implemented? klass, selector
      respond_to? query_method(klass, selector)
    end

    def selector_key selector
      StringUtils.underscore StringUtils.demodulize(selector.class.name)
    end
  end
end
