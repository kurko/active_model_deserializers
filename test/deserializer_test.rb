require "minitest/autorun"
require "active_model/deserializer"
require "active_model/deserializer/adapters/json_api"

module ActiveModel
  class DeserializerTest < ::Minitest::Test
    def setup
      @params = ActionController::Parameters.new({
        users: {
          name: "Alex",
          bio: "Engineer",
          age: "21",
          links: {
            account: 2, # belongs_to
            company: 3, # belongs_to
            country: 4 # belongs_to
          }
        }
      })
      @subject = ActiveModel::Deserializer.new(@params)
    end

    def test_no_adapter
      @subject = ActiveModel::Deserializer.new(@params, adapter_name: :whatever)
      assert_raises ActiveModel::Deserializer::NoAdapter do
        @subject.adapter
      end
    end

    def test_require
      assert @subject.require(:users)
    end

    def test_require_permit
      result = @subject.require(:users).permit(:name, :bio)
      assert_equal "Alex",     result[:name]
      assert_equal "Engineer", result[:bio]
      refute result[:age]
    end

    def test_associations
      result = @subject.require(:users)
                       .permit(:name, :bio)
                       .associations(:account, :company)

      assert_equal "Alex",     result[:name]
      assert_equal "Engineer", result[:bio]
      assert_equal 2,          result[:account_id]
      assert_equal 3,          result[:company_id]
      refute result[:country_id]
      refute result[:age]
    end

    def test_merge!
      result = @subject.require(:users)
                       .permit(:name)
                       .merge!(my_age: 27)
      assert_equal 27, result[:my_age]
    end
  end
end
