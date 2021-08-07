# frozen_string_literal: true

module SnomedQuery
  class Parameter
    attr_accessor :resource_type, :parameter

    def initialize(resourceType:, parameter:)
      @resource_type = resourceType
      @parameter = parameter
    end
  end
end