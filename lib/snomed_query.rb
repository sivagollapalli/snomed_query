# frozen_string_literal: true

require_relative "snomed_query/version"
require_relative "snomed_query/http"
require_relative "snomed_query/operation_outcome"
require_relative "snomed_query/value_set"
require_relative "snomed_query/parameter"
require_relative "snomed_query/code_system"
require "json"
require "faraday"

module SnomedQuery
  SNOMED_VARIANT = "http://snomed.info/sct"
  SYNONYM_SNOMED_CODE = "900000000000013009"

  class Error < StandardError
    attr_accessor :msg

    def initialize(msg)
      @msg = msg
      super(msg)
    end
  end

  class CustomStruct < OpenStruct
    def syn
      parts = []

      parts << part if name == "designation"
      parts = parts.each do |part|
        part.select do |p|
          p.code == SYNONYM_SNOMED_CODE
        end
      end
      parts.flatten.collect(&:valueString).compact
    end
  end
end
