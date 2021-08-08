# frozen_string_literal: true

module SnomedQuery
  class ValueSet
    extend Http

    attr_accessor :resource_type, :url, :expansion

    def initialize(resourceType:, url:, expansion:)
      @resource_type = resourceType
      @url = url
      @expansion = expansion
    end

    def results
      expansion.dig("contains")
    end

    class << self
      def descendants_of(code)
        build_uri_and_send("<#{code}")
      end

      def descendants_or_self_of(code)
        build_uri_and_send("<<#{code}")
      end

      def child_of(code)
        build_uri_and_send("<!#{code}")
      end

      def child_or_self_of(code)
        build_uri_and_send("<<!#{code}")
      end

      def ancestors_of(code)
        build_uri_and_send(">#{code}")
      end

      def ancestors_or_self_of(code)
        build_uri_and_send(">>#{code}")
      end

      def parent_of(code)
        build_uri_and_send(">!#{code}")
      end

      def parent_or_self_of(code)
        build_uri_and_send(">>!#{code}")
      end

      def raw_query(query)
        build_uri_and_send(query)
      end

      def filter(term, count: 10)
        build_uri_and_send("*", { term: term, count: count })
      end

       private

      def build_uri_and_send(ecl_query, **options)
        uri = build_fhir_uri(ecl_query, options)
        response = client.get(uri.request_uri)
        handle_response(response)
      end

      def build_fhir_uri(ecl_query, **options)
        query = URI.encode_www_form(
          { url: "#{SNOMED_VARIANT}?fhir_vs=ecl/#{ecl_query}" }.merge(options)
        )

        URI::HTTP.build(
          path: "/fhir/ValueSet/$expand",
          query: query
        )
      end

      def handle_response(response)
        parsed_response = JSON.parse(response.body).transform_keys(&:to_sym)

        return ValueSet.new(**parsed_response) if response.success?

        raise SnomedQuery::Error, OperationOutcome.new(**parsed_response).error_message
      end
     end
  end
end
