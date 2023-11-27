RSpec.describe Dryer::Factories::BuildFromContract do

  class TestContract < Dry::Validation::Contract
    params do
      required(:foo).filled(:string).value(TestTypes::Foo)
      required(:password).filled(:string).value(TestTypes::Baz)
    end
  end

  module TestTypes
    dry_types = Dry::Types(default: :params)
    Foo = dry_types::String.meta(
      generator: lambda { 'bar' }
    )
    Baz = dry_types::String.meta(
      generator: lambda { 'quux' }
    )
  end
  
  let(:generated_payload) do
    {
      foo: 'bar',
      baz: 'quux'
    }
  end

  it "builds a valid payload from the contract definition" do
    expect(subject.call.to_h).to eq(generated_payload)
  end
end

