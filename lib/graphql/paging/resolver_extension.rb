require 'kaminari'
require_relative 'page_info'

module GraphQL
  module Paging
    module ResolverExtension
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        include GraphQL::Schema::Member::GraphQLTypeNames

        @cached_pagination_types ||= {}

        def self.cached_pagination_types
          @cached_pagination_types
        end

        def paginate(wrapped_type, pagination_options = {}, &block)
          pagination = pagination_type(wrapped_type, **pagination_options)
          pagination.class_eval(&block) if block

          type pagination, null: false

          argument :page, Int, "return the _n_ th page.",       required: false
          argument :per,  Int, "return _n_ elements per page.", required: false
        end

        private

        def pagination_type(wrapped_type, name: nil)
          @@cached_pagination_types ||= {}

          name ||= wrapped_type.graphql_name
          pagination_name = "#{name}Pagination"

          @@cached_pagination_types[pagination_name] ||= begin
            klass = Class.new(_object_class) do
              graphql_name(pagination_name)

              field :page_info, PageInfo,       "Information to aid in pagination.", null: false
              field :nodes,     [wrapped_type], "A list of nodes.",                  null: true

              def page_info
                paged_data
              end

              def nodes
                paged_data
              end

              def all_data
                if object.is_a?(Array) && !object.is_a?(Kaminari::PaginatableArray)
                  object.first
                else
                  object
                end
              end

              def paged_data
                if object.is_a?(Array) && !object.is_a?(Kaminari::PaginatableArray)
                  object.last
                else
                  object
                end
              end
            end
            GraphQL::Paging.const_set(pagination_name, klass)
          end
        end

        def _object_class
          GraphQL::Schema::Object
        end
      end
    end
  end
end
