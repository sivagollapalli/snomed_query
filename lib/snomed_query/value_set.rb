module SnomedQuery
	class ValueSet
		attr_accessor :resource_type, :url, :expansion

		def initialize(resourceType:, url:, expansion:)
			@resource_type = resourceType
			@url = url
			@expansion = expansion
		end

		def results 
			expansion.dig('contains')
		end
	end
end