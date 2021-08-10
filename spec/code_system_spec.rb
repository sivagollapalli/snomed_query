# frozen_string_literal: true

RSpec.describe SnomedQuery::CodeSystem do
  let!(:response) { File.read("./spec/fixtures/covid.json") }

  before(:each) do
    allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
      Faraday::Response.new(status: 200, body: response)
    )
  end

  it "able to get concept based on identifier" do
    actual_response = described_class.lookup(840_539_006)

    expect(actual_response.parameter).to eq(JSON.parse(response).dig("parameter"))
  end

  it "able to get synonms for a given identifier" do
    synonyms = ["COVID-19",
                "Disease caused by 2019 novel coronavirus",
                "Disease caused by 2019-nCoV",
                "Disease caused by Severe acute respiratory syndrome coronavirus 2",
                "Disease caused by Severe acute respiratory syndrome coronavirus 2 (disorder)"]
    expect(described_class.synonyms(840_539_006).sort).to eql(synonyms.sort)
  end
end
