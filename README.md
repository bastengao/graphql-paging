# Graphql::Paging

![](https://travis-ci.org/bastengao/graphql-paging.svg?branch=master)

NOTE: If you need cursor-based pagination, [relay connection](https://graphql-ruby.org/relay/connections.html) is good for you.

A page-based pagination extension for graphql gem, only support kaminari currently.

* [x] support kaminari
* [ ] support will_paginate

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-paging'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphql-paging

## Usage

Require the library

```ruby
require 'graphql/paging'
```

Include `GraphQL::Paging::ResolverExtension` in resolver and use `paginate` method.

```ruby
class UserType < GraphQL::Schema::Object
  graphql_name "User"

  field :id, ID, null: false
  field :name, String, null: false
end

class UserResolver < GraphQL::Schema::Resolver
  include GraphQL::Paging::ResolverExtension

  paginate UserType

  def resolve(**args)
    User.page(args[:page]).per(args[:perPage])
  end
end

class QueryType < GraphQL::Schema::Object
  field :users, resolver: UserResolver
end
```

These code will generate the schema below.

```graphql
type PageInfo {
  currentPage: Int!
  per: Int!
  totalCount: Int!
  totalPages: Int!
}

type Query {
  users(page: Int, per: Int): UserPagination!
}

type User {
  id: ID!
  name: String!
}

type UserPagination {
  nodes: [User!]
  pageInfo: PageInfo!
}
```

### Custom fields

```ruby
class UserResolver < GraphQL::Schema::Resolver
  include GraphQL::Paging::ResolverExtension

  paginate UserType do
    field :count, Int, null: false

    def count
      all_data.count
    end
  end

  def resolve(**args)
    all_data = User.all
    paged_data = all_data.page(args[:page]).per(args[:per_page])
    [all_data, paged_data]
  end
end
```

Pagination object will like this.

```graphql
type UserPagination {
  count: Int!
  nodes: [User!]
  pageInfo: PageInfo!
}
```

### Generate another pagination

`paginate` will generate `#{graphql_name}Pagination` object default and cache it by name. If pagination has different custom fields, specify a name to avoid cache same pagination object.

```ruby
  paginate UserType, "AliasUser"
```

```ruby
type AliasUserPagination {
  nodes: [User!]
  pageInfo: PageInfo!
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bastengao/graphql-paging. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Graphql::Paging project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bastengao/graphql-paging/blob/master/CODE_OF_CONDUCT.md).
