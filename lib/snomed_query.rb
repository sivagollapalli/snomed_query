# frozen_string_literal: true

require_relative "snomed_query/version"
require 'faraday'
require 'json'

module SnomedQuery
  class Error < StandardError
    attr_accessor :msg

    def initialize(msg)
      @msg = msg
      super(msg)
    end
  end

  def client
    @client ||= ::Faraday.new(
      url: ENV['SNOMED_SERVER_URL'],
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def details(code)
    uri = URI::HTTP.build(
      path: '/fhir/ValueSet/$expand', 
      query: "url=#{snomed_variant}?fhir_vs=ecl/#{code}"
    )

    response = client.get(uri.request_uri)
    handle_response(response)
  end

  private

  def handle_response(response)
    parsed_response = JSON.parse(response.body)

    return parsed_response if response.success?

    raise SnomedQuery::Error.new(parsed_response.dig('issue').first.dig('diagnostics'))
  end 

  def snomed_variant
    'http://snomed.info/sct'
  end
end
