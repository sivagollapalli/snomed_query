# frozen_string_literal: true

module SnomedQuery
  module Http
    def client
      ::Faraday.new(
        url: ENV["SNOMED_SERVER_URL"],
        headers: { "Content-Type" => "application/json" }
      )
    end
  end
end
