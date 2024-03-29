
# Dryer Factories
Dryer Factories generates test data from an instance of [Dry::Validation::Contract](https://dry-rb.org/gems/dry-validation/1.10/)

## Installation
add the following to you gemfile
```
gem "dryer_factories"
```

## Usage
```
test "POST 200 - successfully creating a user" do
    class SimpleContract < Dry::Validation::Contract
        params do
            required(:email).filled(:string)
            required(:password).filled(:string)
        end
    end

    request = Dryer::Factories::BuildFromContract.call(SimpleContract)
    post "/users", params: request.as_json

    assert_response :success
end
```

## Features
### Built in Generators
This gem currently only provides default generators for `String` `Hash` and `Array` types. Support for other types will be added as needed.
[Documentation for the built in dry types](https://dry-rb.org/gems/dry-types/1.7/built-in-types/)


### Custom Types and Generators
You can create new types based on the existing `Dry::Types` and then provide
a lambda function for your generator as part of the type's metadata

Example:
```
module Contracts
    module Types
        dry_types = Dry::Types(default: :params)
        Email = dry_types::String.meta(
            generator: lambda { Faker::Internet.email }
        )
        Password = dry_types::String.meta(
            generator: lambda { Faker::Internet.password }
        )
    end
end
```

## Limitations
Type contstraints and that are not encoded in the custom generator are ignored.
For example:
```
    required(:contacts).value(:array, min_size?: 3)
```
will not cause the generator to create an array of length 3, it will generate an
array of length 1.
For arrays specifically, there is currently no way to generate an array larger
than length 1.

## Development
This gem is set up to be developed using [Nix](https://nixos.org/) and
[ruby_gem_dev_shell](https://github.com/jbernie2/ruby_gem_dev_shell)
Once you have nix installed you can run `make env` to enter the development
environment and then `make` to see the list of available commands

## Contributing
Please create a github issue to report any problems using the Gem.
Thanks for your help in making testing easier for everyone!

## Versioning
Dryer Factories follows Semantic Versioning 2.0 as defined at https://semver.org.

## License
This code is free to use under the terms of the MIT license.

