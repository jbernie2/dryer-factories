require "dry-validation"
require "debug"
require_relative "../../../../lib/dryer/factories/fields/build.rb"

RSpec.describe Dryer::Factories::Fields::Build do

  module TestTypes
    dry_types = Dry::Types(default: :params)
    Foo = dry_types::String.meta(
      generator: lambda { 'bar' }
    )
    Baz = dry_types::String.meta(
      generator: lambda { 'quux' }
    )
  end

  class ContractWithGenerator < Dry::Validation::Contract
    params do
      required(:foo).filled(:string).value(TestTypes::Foo)
    end
  end

  class ContractWithoutGenerator < Dry::Validation::Contract
    params do
      required(:foo).filled(:string)
    end
  end

  class ContractWithHash < Dry::Validation::Contract
    params do
      required(:foo).hash do
        required(:baz).filled(:string).value(TestTypes::Baz)
      end
    end
  end

  class ContractWithArray < Dry::Validation::Contract
    params do
      required(:foo).value(array[TestTypes::Baz])
    end
  end

  let(:contract_field) { contract.schema.types.first }
  let(:subject) do
    described_class.call(
      name: contract_field[0],
      type: contract_field[1]
    )
  end

  context "when a generator for the type is supplied" do
    let(:contract) { ContractWithGenerator }

    let(:result) do
      { foo: 'bar' }
    end

    it "uses the generator to create a value" do
      expect(subject).to eq(result)
    end
  end

  context "when no generator is supplied" do
    let(:contract) { ContractWithoutGenerator }

    it "uses the default generator for that type" do
      expect(subject[:foo]).to match(/\h{8}-(\h{4}-){3}\h{12}/)
    end
  end

  context "when the type is a hash" do
    let(:contract) { ContractWithHash }

    let(:result) do
      { foo: { baz: 'quux' } }
    end

    it "recursively generates a value" do
      expect(subject).to eq(result)
    end
  end

  context "when the type is an array" do
    let(:contract) { ContractWithArray }

    let(:result) do
      { foo: ['quux'] }
    end

    it "recursively generates a value" do
      expect(subject).to eq(result)
    end
  end
end
