module ActiveModel
  class Deserializer
    class NoAdapter < StandardError; end

    def initialize(params, adapter_name: :json_api)
      @original_params = params.dup
      @params = params
      @adapter_name = adapter_name
    end

    def require(root_key)
      @root_key = root_key
      @params = @params.require(root_key)
      self
    end

    def permit(*attributes)
      @params = @params.permit(attributes)
      self
    end

    def associations(*attributes)
      associations = adapter.fetch_associations(*attributes)
      @params.merge!(associations)
      self
    end

    def method_missing(method_name, *args)
      if @params.respond_to?(method_name)
        @params.public_send(method_name, *args)
      else
        super
      end
    end

    def [](value)
      @params[value]
    end

    def adapter
      adapter_class.new(
        params: original_params,
        root_key: @root_key
      )
    end

    def inspect
      @params.inspect
    end

    private

    attr_reader :params, :original_params, :adapter_name

    def adapter_class
      if adapter_name == :json_api
        ActiveModel::Deserializer::Adapters::JsonApi
      else
        raise NoAdapter, "#{adapter_name} is not supported"
      end
    end
  end
end
