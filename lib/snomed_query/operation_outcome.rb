# frozen_string_literal: true

module SnomedQuery
	class OperationOutcome
		attr_accessor :resource_type, :issue

		def initialize(resourceType:, issue:)
			@resource_type = resourceType
			@issue = issue
		end

		def error_message
			issue.first.dig('diagnostics')
		end
	end
end