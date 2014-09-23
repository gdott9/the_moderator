# TheModerator

[![Build Status](https://travis-ci.org/gdott9/the_moderator.svg?branch=master)](https://travis-ci.org/gdott9/the_moderator)

Moderate fields before their insertion in the database by serializing and saving them into a separate 'moderations' table.

## Installation

Add this line to your application's Gemfile:

    gem 'the_moderator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install the_moderator

Then use the generator for the migration and the basic `Moderation` model:

    $ rails generate the_moderator:install

## Usage

To use `TheModerator`, you need to include `TheModerator::Model` in the models you want to moderate.

```ruby
class Article
  include TheModerator::Model
end
```

The `Moderation` model added by the genenrator is used to access the moderations.

### Moderate attributes

This gem adds 3 methods to your models.

- `moderate`
- `moderated?`
- `moderated_fields_for(assoc)`

### Manage moderations

To list pending moderations, you can use the `Moderation` model

```ruby
Moderation.all
```

You can access the moderations for a specific object with

```ruby
post = Post.last
post.moderations
```

A `Moderation` instance has 4 methods:
- `moderation.data` returns a hash of the moderated attributes
- `moderation.data_display` returns a user-friendly hash to display the moderated attributes
- `moderation.preview`
- `moderation.accept` modifies the moderated object with the specified attributes and saves it
- `moderation.discard` destroys the moderation

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
