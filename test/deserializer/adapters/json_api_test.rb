require "minitest/autorun"
require "active_model/deserializer/adapters/json_api"

module ActiveModel
  class Deserializer
    class Adapters
      class JsonApiTest < ::Minitest::Test
        def setup
          @params = ActionController::Parameters.new({
            users: {
              name: "Alex",
              bio: "Engineer",
              age: "21",
              links: {
                account: 2,
                company: 3,
                country: 4
              }
            }
          })
          @subject = ActiveModel::Deserializer::Adapters::JsonApi.new(
            params: @params,
            root_key: :users
          )
        end

        def test_fetch_associations
          result = @subject.fetch_associations(:account, :company)
          assert_equal 2, result[:account_id]
          assert_equal 3, result[:company_id]
          refute result[:country_id]
        end
      end
    end
  end
end
