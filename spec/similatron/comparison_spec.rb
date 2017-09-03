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

  it "knows how to turn itself to JSON-like data" do
    args = {
      original: "one",
      generated: "other",
      diff: "diff_path.png",
      score: 100
    }
    comparison = Similatron::Comparison.new(args)

    expect(comparison.as_json).to eq(args.merge(same: false))
  end

end
