require_relative "./simple_service.rb"
require_relative "./generated_payload.rb"
require_relative "./fields/build.rb"

module Dryer
  module Factories
    class BuildFromContract < SimpleService
      def initialize(contract)
        @contract = contract
        check_contract_type!
      end

      def check_contract_type!
        raise(
          "#{self.class}.call: Argument must be an instance "+
          "or subclass of Dry::Validation::Contract"
        ) unless contract.respond_to?(:ancestors) &&
          contract.ancestors.include?(Dry::Validation::Contract)
      end

      def call
        gen_object = Object.new
        contract.schema.types.inject({}) do |fields, (field_name, field_type)|
          fields.merge(Fields::Build.call(
            name: field_name.to_sym,
            type: field_type
          ))
        end.then do |fields|
          GeneratedPayload.new(
            contract: contract,
            fields: fields
          )
        end
      end

      attr_reader :contract
    end
  end
end
