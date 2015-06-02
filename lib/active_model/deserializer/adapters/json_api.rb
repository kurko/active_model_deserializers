module ActiveModel
  class Deserializer
    class Adapters
      class JsonApi
        def initialize(params:, root_key:)
          @params = params
          @root_key = root_key
        end

        def fetch_associations(*whitelist)
          return {} unless links = params[root_key][:links]
          result = {}
          links.each do |key, value|
            next unless whitelist.include?(key.to_sym)
            result[:"#{key}_id"] = value
          end

          result
        end

        private

        attr_reader :params, :root_key
      end
    end
  end
end
