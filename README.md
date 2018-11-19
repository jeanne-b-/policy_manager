# PolicyManager

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'policy_manager'
```

And then execute:

    $ bundle

## Generate migrations

```
rails g policy_manager:install
rake db:migrate
```

## Configuration

Create a file names `policy_manager.rb` in your `config/initializers` directory

```ruby
PolicyManager::Config.setup do |config|
  config.is_admin_method = -> (user) { user.has_role?(:basic_staff) }
  config.registery = {user: [
    :projects_users,
    :messages,
    :user_candidature,
    scale_teams: {finder: -> (user) { ScaleTeam.where(user_id: user.id) }},
    user_login: {finder: -> (user) { UserLogin.where(user_id: user.id) }}
  ]}
end
```

### Available Options

`is_admin_method` The method used to authenticate admin (they can edit/create Terms)

`registery` The registery used to create a zip file with all the user's data

### Configure your registery

You can add one registery per user model and as many associations as you want:
```ruby
PolicyManager::Config.setup do |config|
  config.registery = {
    user: [:messages, :posts]
    admin: [:messages]
  },
end
```

By default, we use the supplied association and serialize all attributes, but you can specify a method to retrieve other associated records:
```ruby
scale_teams: {finder: -> (user) { ScaleTeam.where(user_id: user.id) }}
```

To change the default serialization, you can add a specific serialiazer to your app:
```
$ rails generate policy_manager:portability_serializer message
```
Will generate a serializer for the class Message, with all its attributes and its `belongs_to` and `has_many` relations.
Don't forget to review it, and make necessary changes.

### Configure your users

Add the concern in the user class, for exemple in app/models/user.rb:

```ruby
class User < ApplicationRecord
  #...
  include PolicyManager::Concerns::PoliciesResource
  #...
end
```

This adds the approriate relationships to your users.

## Add routes to your app
```ruby
# config/routes.rb
mount PolicyManager::Engine => "/policies"
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PolicyManager project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/policy_manager/blob/master/CODE_OF_CONDUCT.md).
