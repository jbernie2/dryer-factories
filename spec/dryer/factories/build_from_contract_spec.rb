require "dry-validation"
require_relative "../../../lib/dryer/factories/build_from_contract.rb"
require_relative "../../../lib/dryer/factories/generated_payload.rb"

RSpec.describe Dryer::Factories::BuildFromContract do

  module TestTypes
    dry_types = Dry::Types(default: :params)
    Foo = dry_types::String.meta(
      generator: lambda { 'bar' }
    )
    Baz = dry_types::String.meta(
      generator: lambda { 'quux' }
    )
  end

  class SimpleTestContract < Dry::Validation::Contract
    params do
      required(:foo).filled(:string).value(TestTypes::Foo)
      required(:baz).filled(:string).value(TestTypes::Baz)
    end
  end

  class ComplexTestContract < Dry::Validation::Contract
    params do
      required(:foo).filled(:string).value(TestTypes::Foo)
      required(:baz).filled(:string).value(TestTypes::Baz)
      required(:something).hash do
        required(:baz).filled(:string).value(TestTypes::Baz)
      end
      required(:list).value(array[TestTypes::Foo], size?: 3)
    end
  end
  
  let(:contract) { SimpleTestContract }
  let(:generated_payload) do
    {
      foo: 'bar',
      baz: 'quux'
    }
  end


  subject { described_class.call(contract) }

  it "builds a valid payload from the contract definition" do
    expect(subject.to_h).to eq(generated_payload)
  end

  it "creates an instance of the GeneratedPayload class" do
    expect(subject.class).to eq(Dryer::Factories::GeneratedPayload)
  end

  it "knows which contract was used to generate the paylod" do
    expect(subject.contract).to eq(contract)
  end

  #context "for complex contracts" do

    #let(:contract) { ComplexTestContract }
    #let(:generated_payload) do
      #{
        #foo: 'bar',
        #baz: 'quux',
        #something: { baz: 'quux' },
        #list: [ 'bar', 'bar', 'bar' ]
      #}
    #end

    #it "builds a valid payload from the contract definition" do
      #expect(subject.to_h).to eq(generated_payload)
    #end
  #end
end

