module Dryer
  module Factories
    class GeneratedPayload
      def initialize(contract:, fields:)
        @contract = contract
        @fields = fields
        create_instance_variables
      end

      def create_instance_variables
        fields.inject(self) do |obj, (name, value)|
          self.define_singleton_method(name.to_sym) { value }
        end
      end

      def to_h
        fields
      end

      def as_json
        to_h
      end

      def to_json
        to_h.to_json
      end

      attr_reader :contract
      private
      attr_reader :fields
    end
  end
end
