# frozen_string_literal: true
require "e_codices_harvester"

RSpec.describe ECodicesHarvester::Harvester do
  subject(:harvester) { described_class.new(uri: uri) }
  let(:uri) { URI("https://www.e-codices.unifr.ch/metadata/iiif/collection.json") }

  it "can fetch collections" do
    expect(harvester.collections.count).to eq(195)
    expect(harvester.collections.first).to eq("fluff")
  end

  it "can fetch manifests" do
    collection = URI("https://www.e-codices.unifr.ch/metadata/iiif/collection/cma.json")
    expect(harvester.fetch_manifests(collection).count).to eq(1)
  end
end
