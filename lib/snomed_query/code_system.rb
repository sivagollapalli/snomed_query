# frozen_string_literal: true

module SnomedQuery
  class CodeSystem
    extend Http

    class << self
      def lookup(identifier)
        uri = build_fhir_uri(identifier)
        response = client.get(uri.request_uri)
        handle_response(response)
      end

      def synonyms(identifier)
        JSON.parse(
          lookup(identifier).parameter.to_json,
          object_class: CustomStruct
        ).collect(&:syn).flatten
      end

      def handle_response(response)
        parsed_response = JSON.parse(response.body).transform_keys(&:to_sym)
        return Parameter.new(**parsed_response) if response.success?

        raise SnomedQuery::Error, OperationOutcome.new(**parsed_response).error_message
      end

      def build_fhir_uri(identifier)
        URI::HTTP.build(
          path: "/fhir/CodeSystem/$lookup",
          query: "url=#{SNOMED_VARIANT}&code=#{identifier}"
        )
      end
    end
  end
end
