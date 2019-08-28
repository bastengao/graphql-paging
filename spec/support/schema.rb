class UserType < GraphQL::Schema::Object
  graphql_name "User"

  field :id, ID, null: false
  field :name, String, null: true
end

USERS = (0..10).map do |i|
  {
    id: i,
    name: i.to_s
  }
end

class UserResolver < GraphQL::Schema::Resolver
  include GraphQL::Paging::ResolverExtension

  paginate UserType

  def resolve(**args)
    Kaminari.paginate_array(USERS).page(args[:page]).per(args[:per])
  end
end

class UserResolverWithArgs < GraphQL::Schema::Resolver
  include GraphQL::Paging::ResolverExtension

  paginate UserType

  argument :even_id, Boolean, required: false

  def resolve(**args)
    users = USERS.select { |u| u[:id].even? } if args[:even_id]

    Kaminari.paginate_array(users).page(args[:page]).per(args[:per])
  end
end

class UserResolverCustomFields < GraphQL::Schema::Resolver
  include GraphQL::Paging::ResolverExtension

  paginate UserType, name: "ExtendedUser" do
    field :count, Int, null: true

    def count
      all_data.count
    end
  end

  def resolve(**args)
    paged_data = Kaminari.paginate_array(USERS).page(args[:page]).per(args[:per])
    [USERS, paged_data]
  end
end

class QueryType < GraphQL::Schema::Object
  field :users,             resolver: UserResolver
  field :usersWithArgs,     resolver: UserResolverWithArgs
  field :usersCustomFields, resolver: UserResolverCustomFields
  field :test, {
    type: UserType,
    arguments: [
      [:page, type: 'Int', required: false],
      [:per, type: 'Int', required: false]
    ],
    null: false
  } do
    argument :my, Int, required: true
  end
end

class Schema < GraphQL::Schema
  query QueryType
end