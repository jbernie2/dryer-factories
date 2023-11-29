require_relative "../../../lib/dryer/factories/version.rb"

RSpec.describe Dryer::Factories do
  it "returns the current gem version" do
    expect(Dryer::Factories::VERSION).to be_truthy
  end
end
