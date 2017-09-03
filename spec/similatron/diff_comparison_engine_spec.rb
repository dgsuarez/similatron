require 'spec_helper'

describe Similatron::DiffComparisonEngine do

  before :each do
    FileUtils.mkdir_p("tmp/diffs")
    @engine = Similatron::DiffComparisonEngine.new(diffs_path: "tmp/diffs")
  end

  it "compares the same text to itself and says they are the same" do
    comparison = @engine.compare(
      original: "spec/assets/bug_1.txt",
      generated: "spec/assets/bug_1.txt"
    )

    expect(comparison.same?).to be_truthy
  end

  it "compares different texts" do
    comparison = @engine.compare(
      original: "spec/assets/bug_1.txt",
      generated: "spec/assets/bug_1_rotate.txt"
    )

    expect(comparison.same?).to be_falsy
  end

  it "saves a diff file" do
    comparison = @engine.compare(
      original: "spec/assets/bug_1.txt",
      generated: "spec/assets/bug_1_rotate.txt"
    )

    expect(File.size(comparison.diff)).to be > 0
  end

  it "gets a meaningful score" do
    comparison = @engine.compare(
      original: "spec/assets/bug_1.txt",
      generated: "spec/assets/bug_1_rotate.txt"
    )

    expect(comparison.score).to eq 2.0
  end

end
