require_relative "../simple_service.rb"

module Dryer
  module Factories
    module Fields
      class Build < SimpleService
        def initialize(name:, type:)
          @name = name
          @type = type
        end

        def call
          build_field(name, type)
        end

        private

        def build_field(field_name, field_type)
          if field_type.meta[:generator]
            {field_name => field_type.meta[:generator].call}
          else
            case field_type.type.name
            when "String"
              {field_name => SecureRandom.uuid.to_s }
            end
          end
        end

        attr_reader :name, :type
      end
    end
  end
end
