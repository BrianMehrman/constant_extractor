# ConstantExtractor

The constant extractor is a simple gem to help identify the modules and classes
defined within a ruby file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'constant_extractor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install constant_extractor

## Usage

With a ruby file named `foo.rb` you can extract the class name from the file
```ruby
# foo.rb
module Something
  class Foo
    def bar
      "bar"
    end
  end
end
```

The module ConstantExtractor has a method `process` that receives the full filepath
to the ruby file you want to extract the class or module names from.

```ruby
> nodes = ConstantExtractor.process('foo.rb')
=> [s(:module, :Something), s(:class, :"Something::Foo")]
> nodes.flat_map(&:children)
=> [:Something, :"Something::Foo"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## TODO

[ ] - Add abstaction for class and module definintions


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/constant_extractor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ConstantExtractor project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/constant_extractor/blob/master/CODE_OF_CONDUCT.md).
