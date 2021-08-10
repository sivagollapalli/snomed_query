# frozen_string_literal: true

RSpec.describe SnomedQuery::ValueSet do
  context "queries" do
    before(:each) do
      allow(described_class).to receive(:build_uri_and_send).and_return(true)
    end

    it "should be able to pull decedents" do
      described_class.descendants_of(123_456)
      expect(described_class).to have_received(:build_uri_and_send).with("<123456")
    end

    it "should be able to pull decedents along with self" do
      described_class.descendants_or_self_of(123_456)
      expect(described_class).to have_received(:build_uri_and_send).with("<<123456")
    end

    it "should be able to pull children for a given snomed" do
      described_class.child_of(123_456)
      expect(described_class).to have_received(:build_uri_and_send).with("<!123456")
    end

    it "should be able to pull children along with self for a given snomed" do
      described_class.child_or_self_of(123_456)
      expect(described_class).to have_received(:build_uri_and_send).with("<<!123456")
    end

    it "should be able to pull all ancestors" do
      described_class.ancestors_of(123_456)
      expect(described_class).to have_received(:build_uri_and_send).with(">123456")
    end

    it "should be able to pull all ancestors and self" do
      described_class.ancestors_or_self_of(123_456)
      expect(described_class).to have_received(:build_uri_and_send).with(">>123456")
    end

    it "should be able to pull parent" do
      described_class.parent_of(123_456)
      expect(described_class).to have_received(:build_uri_and_send).with(">!123456")
    end

    it "should be able to pull parent along with self" do
      described_class.parent_or_self_of(123_456)
      expect(described_class).to have_received(:build_uri_and_send).with(">>!123456")
    end

    it "should be able query using raw ECL" do
      query = "281666001|family history of disorder|:246090004|associated finding|=22298006|myocardial infarction|"
      described_class.raw_query(query)
      expect(described_class).to have_received(:build_uri_and_send).with(query)
    end

    it "should be filter snomed using a term" do
      described_class.filter("heart")
      expect(described_class).to have_received(:build_uri_and_send).with("*", { term: "heart", count: 10 })
    end

    it "should be able to set of count on filtering" do
      described_class.filter("heart", count: 100)
      expect(described_class).to have_received(:build_uri_and_send).with("*", { term: "heart", count: 100 })
    end

    it "should build FHIR URI for a given query" do
      uri = described_class.send(:build_fhir_uri, "*", { term: "heart", count: 100 })
      expect(uri.request_uri).to eq("/fhir/ValueSet/$expand?url=http%3A%2F%2Fsnomed.info%2Fsct%3Ffhir_vs%3Decl%2F*&term=heart&count=100")
    end
  end

  it "should query the FHIR server" do
    response = {
      "resourceType": "ValueSet",
      "url": "http://snomed.info/sct?fhir_vs=ecl/22298006",
      "expansion": {
        "total": 1,
        "offset": 0,
        "contains": [
          {
            "system": "http://snomed.info/sct",
            "code": "22298006",
            "display": "Myocardial infarct"
          }
        ]
      }
    }

    allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(Faraday::Response.new(status: 200, body: response.to_json))
    actual_reponse = described_class.send(:build_uri_and_send, 22_298_006)
    expect(actual_reponse.results.first).to eq(response.dig(:expansion, :contains).first.transform_keys(&:to_s))
  end

  it "should return SnomedQuery::Error upon API failure" do
    response = {
      "resourceType": "OperationOutcome",
      "issue": [
        {
          "severity": "error",
          "code": "processing",
          "diagnostics": "Failed to call access method: org.snomed.langauges.ecl.ECLException: Failed to parse ECL 'test'"
        }
      ]
    }

    allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(Faraday::Response.new(status: 500, body: response.to_json))
    expect { described_class.send(:build_uri_and_send, "test") }.to raise_error(SnomedQuery::Error, "Failed to call access method: org.snomed.langauges.ecl.ECLException: Failed to parse ECL 'test'")
  end
end
