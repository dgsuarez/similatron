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
    generated = "tmp/generated_test.jpg"
    FileUtils.rm_f(generated)

    @run.compare(
      original: "spec/assets/bug_1.jpg",
      generated: generated
    )

    expect(File.exist?(generated)).to be_truthy

    FileUtils.rm_f("tmp/generated_test.jpg")
  end

end
