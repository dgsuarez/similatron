require 'spec_helper'

describe Similatron::Run do

  before :each do
    @run = Similatron::Run.new
    @run.start
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

  it "knows that the comparison has overwritten" do
    original = "tmp/original_test.jpg"
    FileUtils.rm_f(original)

    @run.compare(
      original: original,
      generated: "spec/assets/bug_1.jpg"
    )

    comparison = @run.comparisons.first

    expect(comparison.overwrite?).to be_truthy

    FileUtils.rm_f(original)
  end

  it "can raise an error when the comparison fails" do
    expect do
      @run.compare!(
        original: "spec/assets/bug_1.jpg",
        generated: "spec/assets/bug_1_rotate.jpg"
      )
    end.to raise_error(/bug_1.jpg/)
  end

  it "creates a JSON report on completion" do
    @run.compare(
      original: "spec/assets/bug_1.jpg",
      generated: "spec/assets/bug_1.jpg"
    )

    @run.compare(
      original: "spec/assets/bug_1.jpg",
      generated: "spec/assets/bug_1_rotate.jpg"
    )

    @run.complete

    json_report = File.read(@run.json_report_path)

    expect(json_report).to match(/"same":true/)
    expect(json_report).to match(/"same":false/)
  end

  it "creates an HTML report on completion" do
    @run.compare(
      original: "spec/assets/bug_2.jpg",
      generated: "spec/assets/bug_2.jpg"
    )

    @run.compare(
      original: "spec/assets/bug_1.jpg",
      generated: "spec/assets/bug_1_rotate.jpg"
    )

    @run.complete

    html_report = File.read(@run.html_report_path)

    expect(html_report).to_not match(/bug_2/)
    expect(html_report).to match(/bug_1/)
  end

end
