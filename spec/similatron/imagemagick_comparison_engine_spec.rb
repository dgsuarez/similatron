require 'spec_helper'

describe Similatron::ImagemagickComparisonEngine do

  before :each do
    FileUtils.mkdir_p("tmp/diffs")
    @engine = Similatron::ImagemagickComparisonEngine.new(diffs_path: "tmp/diffs")
  end

  it "compares the same image to itself and says they are the same" do
    comparison = @engine.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_1.jpg"
    )

    expect(comparison.same?).to be_truthy
  end

  it "compares images with different geometry" do
    comparison = @engine.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_2.jpg"
    )

    expect(comparison.same?).to be_falsy
  end

  it "compares different images with same geometry" do
    comparison = @engine.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_1_rotate.jpg"
    )

    expect(comparison.same?).to be_falsy
  end

  it "saves a diff file if it can" do
    comparison = @engine.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_1_rotate.jpg"
    )

    expect(File.size(comparison.diff)).to be > 0
  end

  it "doesn't save a diff file if it can't" do
    comparison = @engine.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_2.jpg"
    )

    expect(comparison.diff).to be_nil
  end

end
