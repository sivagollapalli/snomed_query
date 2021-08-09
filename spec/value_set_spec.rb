# frozen_string_literal: true

RSpec.describe SnomedQuery::ValueSet do
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
end
