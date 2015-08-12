module Aas
  module Repo
    def self.included base
      base
    end

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

    def graph_query klass, selector
      if graph_query_implemented? klass, selector
        send graph_query_method(klass, selector), klass, selector
      else
        raise GraphQueryNotImplementedError, selector
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









#module Aas
#  module Repo
#    #def self.included base
#    #  base.extend ClassMethods
#    #end
#
#    def all klass, 
#
#Chassis::Repo#all(klass, id)
#Chassis::Repo#find(klass, id)
#Chassis::Repo#save(record)
#Chassis::Repo#delete(record)
#Chassis::Repo#first(klass)
#Chassis::Repo#last(klass)
#Chassis::Repo#query(klass, selector)
#Chassis::Repo#graph_query(klass, selector)
#Chassis::Repo#sample(klass)
#Chassis::Repo#empty?(klass)
#Chassis::Repo#count(klass)
#Chassis::Repo#clear
#
#
#
#    module ClassMethods
#      def all
#        data_store.find_all collection_name
#      end
#
#      def collection(explicit_collection_name)
#        @collection_name = explicit_collection_name
#      end
#
#      def collection_name
#        @collection_name ||= default_collection_name
#      end
#
#      def default_collection_name
#        klass_name
#        #ActiveSupport::Inflector.tableize(klass)
#      end
#
#      def data_store
#        #@data_store ||= Curator.data_store
#        @data_store ||= Memory::DataStore.new
#      end
#
#      def data_store=(store)
#        @data_store = store
#      end
#
#      def delete(object)
#        data_store.delete(collection_name, object.id)
#        nil
#      end
#
#      def find_by_created_at(start_time, end_time)
#        _find_by_attribute(:created_at, _format_time_for_index(start_time).._format_time_for_index(end_time))
#      end
#
#      def find_by_updated_at(start_time, end_time)
#        _find_by_attribute(:updated_at, _format_time_for_index(start_time).._format_time_for_index(end_time))
#      end
#
#      def find_by_version(version)
#        _find_by_attribute(:version, version)
#      end
#
#      def find_by_id(id)
#        if hash = data_store.find_by_key(collection_name, id)
#          _deserialize(hash[:key], hash[:data])
#        end
#      end
#
#      #def indexed_fields(*fields)
#      #  @indexed_fields = fields
#
#      #  @indexed_fields.each do |field_name|
#      #    _build_finder_methods(field_name)
#      #  end
#      #end
#
#      def klass_name
#        name.to_s.gsub "Repo", ""
#      end
#
#      def klass
#        Object.const_get klass_name
#      end
#
#      def save object
#        object.touch
#        save_without_timestamps object
#      end
#
#      def save_without_timestamps object
#        if object.guid
#          data_store.save object
#        else
#          object.instance_variable_set("@guid", 'asdf')
#          data_store.save object
#        end
#
#        object
#      end
#    end
#  end
#
#  module Memory
#    class DataStore
#
#      def remove_all_keys
#        @data = {}
#      end
#
#      def reset!
#        remove_all_keys
#      end
#
#      def save(options)
#        bucket = _bucket_name(options[:collection_name])
#        object = options[:value]
#        key = options[:key]
#        indexes = options.fetch(:index, {})
#
#        key = _generate_key(bucket) unless key
#
#        _records(bucket).store(key, object)
#        indexes.each do |index_name, index_data|
#          index = _index(bucket, index_name)
#
#          _normalized_index_values(index_data).each do |index_value|
#            index[index_value] ||= []
#            index[index_value] << key unless index[index_value].include?(key)
#          end
#        end
#
#        key
#      end
#
#      def delete(collection_name, key)
#        bucket = _bucket_name(collection_name)
#        _records(bucket).delete(key)
#        _indices(bucket).each_key do |name|
#          index = _index(bucket, name)
#          index.each do |value, keys|
#            next unless keys.include?(key)
#            index[value].delete(key)
#          end
#          index.delete_if { |value, keys| keys.empty? }
#        end
#      end
#
#      def find_all(collection_name)
#        bucket = _bucket_name(collection_name)
#        _records(bucket).inject([]) do |results, (key,value)|
#          results << {:key => key, :data => value}
#          results
#        end
#      end
#
#      def find_by_key(collection_name, key)
#        bucket = _bucket_name(collection_name)
#        value = _records(bucket).fetch(key, nil)
#        return if value.nil?
#        {:key => key, :data => value}
#      end
#
#      def _data
#        @data ||= {}
#      end
#
#      def _bucket(bucket)
#        _data[bucket] ||= {}
#      end
#
#      def _records(bucket)
#        _bucket(bucket)[:records] ||= {}
#      end
#
#      def _indices(bucket)
#        _bucket(bucket)[:indices] ||= {}
#      end
#
#      def _index(bucket, index_name)
#        _indices(bucket)[index_name] ||= {}
#      end
#
#      def _normalized_index_values(indexed_data)
#        if indexed_data.is_a?(Array)
#          indexed_data
#        else
#          [indexed_data]
#        end
#      end
#
#      def _generate_key(bucket)
#        keys = _records(bucket).keys
#        keys = [0] if keys.empty?
#        keys.max.next
#      end
#
#      def _bucket_name(name)
#        "#{Curator.config.environment}:#{name}"
#      end
#    end
#  end
#end
