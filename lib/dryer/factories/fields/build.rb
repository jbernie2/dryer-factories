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
          { field_name => build_field_value(field_type) }
        end

        def build_field_value(field_type)
          generator = field_type.meta[:generator]
          if generator
            generator.call
          else
            case field_type.type.name
            when "String"
              SecureRandom.uuid.to_s
            when "Hash"
              generate_hash(field_type)
            when "Array"
              [ build_field_value(field_type.type.member) ]
            end
          end
        end

        def generate_hash(field_type)
          field_type.keys.inject({}) do |hash, k|
            hash.merge(build_field(k.name, k.type))
          end
        end

        attr_reader :name, :type
      end
    end
  end
end
