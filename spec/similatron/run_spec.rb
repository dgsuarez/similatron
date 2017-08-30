require 'spec_helper'

describe Similatron::Run do

  before :each do
    @run = Similatron::Run.new
  end

  it "stores the comparisons it does" do
    @run.compare(
      original: "spec/assets/bug_1.jpg",
      generated: "spec/assets/bug_1.jpg"
    )

    @run.compare(
      original: "spec/assets/bug_1.jpg",
      generated: "spec/assets/bug_1_rotate.jpg"
    )

    expect(@run.comparisons.size).to eq 2
  end

  it "creates a copy of the original if the generated is not there" do
    original = "tmp/original_test.jpg"
    FileUtils.rm_f(original)

    @run.compare(
      original: original,
      generated: "spec/assets/bug_1.jpg"
    )

    expect(File.exist?(original)).to be_truthy

    FileUtils.rm_f(original)
  end

end
