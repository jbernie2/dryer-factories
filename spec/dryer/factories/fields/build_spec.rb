require "dry-validation"
require_relative "../../../../lib/dryer/factories/fields/build.rb"

RSpec.describe Dryer::Factories::Fields::Build do

  before do
    stub_const(
      "TestTypeFoo",
      Dry::Types(default: :params)::String.meta(
        generator: lambda { 'bar' }
      )
    )

    stub_const(
      "TestTypeBaz",
      Dry::Types(default: :params)::String.meta(
        generator: lambda { 'quux' }
      )
    )

    stub_const(
      "ContractWithGenerator",
      Class.new(Dry::Validation::Contract) do
        params do
          required(:foo).filled(:string).value(TestTypeFoo)
        end
      end
    )

    stub_const(
      "ContractWithoutGenerator",
      Class.new(Dry::Validation::Contract) do
        params do
          required(:foo).filled(:string)
        end
      end
    )

    stub_const(
      "ContractWithHash",
      Class.new(Dry::Validation::Contract) do
        params do
          required(:foo).hash do
            required(:baz).filled(:string).value(TestTypeBaz)
          end
        end
      end
    )

    stub_const(
      "ContractWithArray",
      Class.new(Dry::Validation::Contract) do
        params do
          required(:foo).value(array[TestTypeBaz])
        end
      end
    )

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
