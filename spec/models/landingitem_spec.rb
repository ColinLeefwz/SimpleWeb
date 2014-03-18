require 'spec_helper'

describe Landingitem do
  helper_objects

  it "created one after creating a new Article" do
    article
    expect(Landingitem.count).to eq 1
  end
end
