module GraphQL
  module Paging
    class PageInfo < GraphQL::Schema::Object
      graphql_name "PagingPageInfo"

      field :total_count,  Integer, method: :total_count,  null: false
      field :total_pages,  Integer, method: :total_pages,  null: false
      field :current_page, Integer, method: :current_page, null: false
      field :per,          Integer, method: :limit_value,  null: false
    end
  end
end
