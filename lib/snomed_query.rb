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

  def details(code)
    build_uri_and_send(code)
  end

  def descendant_of(code)
    build_uri_and_send("<#{code}")
  end

  def descendant_or_self_of(code)
    build_uri_and_send("<<#{code}")
  end

  def child_of(code)
    build_uri_and_send("<!#{code}")
  end

  def child_or_self_of(code)
    build_uri_and_send("<<!#{code}")
  end

  def ancestor_of(code)
    build_uri_and_send(">#{code}")
  end

  def ancestor_or_self_of(code)
    build_uri_and_send(">>#{code}")
  end

  def parent_of(code)
    build_uri_and_send(">!#{code}")
  end

  def parent_or_self_of(code)
    build_uri_and_send(">>!#{code}")
  end

  private

  def build_uri_and_send(ecl_query)
    uri = build_fhir_uri(ecl_query)
    response = client.get(uri.request_uri)
    handle_response(response)
  end

  def client
    ::Faraday.new(
      url: ENV['SNOMED_SERVER_URL'],
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def build_fhir_uri(ecl_query)
    URI::HTTP.build(
      path: '/fhir/ValueSet/$expand', 
      query: "url=#{snomed_variant}?fhir_vs=ecl/#{ecl_query}"
    )
  end

  def handle_response(response)
    parsed_response = JSON.parse(response.body)

    return parsed_response if response.success?

    raise SnomedQuery::Error.new(parsed_response.dig('issue').first.dig('diagnostics'))
  end 

  def snomed_variant
    'http://snomed.info/sct'
  end
end
