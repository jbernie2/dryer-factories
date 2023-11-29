require "rubygems"

module Dryer
  module Factories
    VERSION = Gem::Specification::load(
      "./dryer_factories.gemspec"
    ).version
  end
end
