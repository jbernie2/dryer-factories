#require File.expand_path('lib/dryer/factories/version.rb', __dir__)
Gem::Specification.new do |spec|
  spec.name                  = 'dryer_factories'

  # this should be imported from lib/dryer/factories/version.rb
  # but I am having nix issues with importing the version file
  # when this file is evaluated
  #spec.version               = Dryer::Factories::Version 
  spec.version               = "0.0.1" 
  spec.authors               = ['John Bernier']
  spec.email                 = ['john.b.bernier@gmail.com']
  spec.summary               = 'Generate payloads from dry-validation definitions'
  spec.description           = <<~DOC
    An extension of the Dry family of gems (dry-rb.org).
    This gem can generate valid payloads for contracts defined using the
    dry-validation gem.
  DOC
  spec.homepage              = 'https://github.com/jbernie2/dryer-factories'
  spec.license               = 'MIT'
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 3.0.0'
  spec.files = Dir[
    'README.md',
    'LICENSE',
    'CHANGELOG.md',
    'lib/**/*.rb',
    'dryer_factories.gemspec',
    '.github/*.md',
    'Gemfile'
  ]
  spec.add_dependency "dry-validation", "~> 1.10"
  spec.add_dependency "dry-types", "~> 1.7"
  spec.add_dependency "faker", "~> 1.6"
  spec.add_development_dependency "rspec", "~> 3.10"
end
