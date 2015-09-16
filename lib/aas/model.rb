module Aas
  module Model
    def self.included base
      base.extend ClassMethods
      base.instance_eval do
        attr_reader :id, :created_at, :updated_at
        attr_writer :version
      end
    end

    def initialize args = {}
      method_strings = methods.map &:to_s
      args.each do |attribute, value|
        send "#{attribute}=", value if method_strings.include? "#{attribute}="
        instance_variable_set "@#{attribute}", value if method_strings.include? attribute.to_s
      end
    end

    def id= new_id
      @id = new_id if @id.nil?
    end

    def new_record?
      id.nil?
    end

    def persisted?
      !new_record?
    end

    def touch
      now = Time.now.utc
      @created_at = now if @created_at.nil?
      @updated_at = now
    end

    def version
      @version || self.class.version
    end

    def == other
      self.id == other.id
    end

    module ClassMethods
      def current_version number
        @version = number
      end

      def version
        @version || 0
      end
    end
  end
end
