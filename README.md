# PolicyManager

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'policy_manager'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install policy_manager

## Generate migrations

```
rails g policy_manager:install
```

## Add routes to your app
```ruby
# config/routes.rb
mount PolicyManager::Engine => "/policies"
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PolicyManager project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/policy_manager/blob/master/CODE_OF_CONDUCT.md).
