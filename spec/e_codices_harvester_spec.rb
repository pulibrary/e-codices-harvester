# frozen_string_literal: true
require "e_codices_harvester"

RSpec.describe ECodicesHarvester do
  it "has a version number" do
    expect(ECodicesHarvester::VERSION).not_to be nil
  end
end
