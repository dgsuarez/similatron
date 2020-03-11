require 'spec_helper'

describe Similatron::PdfComparisonEngine do
  before :each do
    FileUtils.mkdir_p("tmp/diffs")
    @engine = Similatron::PdfComparisonEngine.new(diffs_path: "tmp/diffs")
  end

  it "compares multipage PDFs when they are different" do
    comparison = @engine.compare(
      expected: "spec/assets/multipage_sample.pdf",
      actual: "spec/assets/multipage_sample_2.pdf"
    )

    expect(comparison.same?).to be_falsy
  end

  it "compares multipage PDFs when they are equal" do
    comparison = @engine.compare(
      expected: "spec/assets/multipage_sample.pdf",
      actual: "spec/assets/multipage_sample.pdf"
    )

    expect(comparison.same?).to be_truthy
  end

  it "returns a comparison with the expected/actual paths" do
    comparison = @engine.compare(
      expected: "spec/assets/multipage_sample.pdf",
      actual: "spec/assets/multipage_sample.pdf"
    )

    expect(comparison.expected).to eq("spec/assets/multipage_sample.pdf")
  end
end
