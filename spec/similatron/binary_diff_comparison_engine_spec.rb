require 'spec_helper'

describe Similatron::BinaryDiffComparisonEngine do

  before :each do
    FileUtils.mkdir_p("tmp/diffs")
    @engine = Similatron::BinaryDiffComparisonEngine.new(diffs_path: "tmp/diffs")
  end

  it "compares the same image to itself and says they are the same" do
    comparison = @engine.compare(
      original: "spec/assets/bug_1.jpg",
      generated: "spec/assets/bug_1.jpg"
    )

    expect(comparison.same?).to be_truthy
  end

  it "compares different images and says so" do
    comparison = @engine.compare(
      original: "spec/assets/bug_1.jpg",
      generated: "spec/assets/bug_2.jpg"
    )

    expect(comparison.same?).to be_falsy
  end

  it "never saves a diff file" do
    comparison = @engine.compare(
      original: "spec/assets/bug_1.jpg",
      generated: "spec/assets/bug_1_rotate.jpg"
    )

    expect(comparison.diff).to be_nil
  end

end
