# frozen_string_literal: true

require_relative "snomed_query/version"
require_relative 'snomed_query/http'
require_relative 'snomed_query/operation_outcome'
require_relative 'snomed_query/value_set'
require_relative 'snomed_query/parameter'
require_relative 'snomed_query/code_system'
require 'json'
require 'faraday'

module SnomedQuery
  SNOMED_VARIANT = 'http://snomed.info/sct'.freeze

  class Error < StandardError
    attr_accessor :msg

    def initialize(msg)
      @msg = msg
      super(msg)
    end
  end
end
