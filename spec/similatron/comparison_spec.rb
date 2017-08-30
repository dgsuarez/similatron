require 'spec_helper'

describe Similatron::Comparison do

  it "can raise an error with all the information about itself" do

    comparison = Similatron::Comparison.new(
      original: "one",
      generated: "other",
      diff: "some_diff",
      score: 70
    )

    expected = /Found other different from one/

    expect { comparison.raise_when_different }.to raise_error(expected)
  end

  it "doesn't raise if they are equal" do
    comparison = Similatron::Comparison.new(
      original: "one",
      generated: "other",
      diff: nil,
      score: 0
    )

    expect { comparison.raise_when_different }.to_not raise_error
  end

end
