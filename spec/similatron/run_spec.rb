require 'spec_helper'

describe Similatron::Run do

  before :each do
    @run = Similatron::Run.new
    @run.start
  end

  it "stores the comparisons it does" do
    @run.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_1.jpg"
    )

    @run.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_1_rotate.jpg"
    )

    expect(@run.comparisons.size).to eq 2
  end

  it "knows the best comparison engine to use" do
    @run.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_1_rotate.jpg"
    )

    @run.compare(
      expected: "spec/assets/bug_1.txt",
      actual: "spec/assets/bug_1_rotate.txt"
    )

    expect(@run.comparisons.first.diff).to match(/\.jpg/)
    expect(@run.comparisons.last.diff).to match(/\.diff/)
  end

  it "creates a copy of the expected if the actual is not there" do
    expected = "tmp/expected_test.jpg"
    FileUtils.rm_f(expected)

    @run.compare(
      expected: expected,
      actual: "spec/assets/bug_1.jpg"
    )

    expect(File.exist?(expected)).to be_truthy

    FileUtils.rm_f(expected)
  end

  it "knows that the comparison has overwritten" do
    expected = "tmp/expected_test.jpg"
    FileUtils.rm_f(expected)

    @run.compare(
      expected: expected,
      actual: "spec/assets/bug_1.jpg"
    )

    comparison = @run.comparisons.first

    expect(comparison.overwrite?).to be_truthy

    FileUtils.rm_f(expected)
  end

  it "can raise an error when the comparison fails" do
    expect do
      @run.compare!(
        expected: "spec/assets/bug_1.jpg",
        actual: "spec/assets/bug_1_rotate.jpg"
      )
    end.to raise_error(/bug_1.jpg/)
  end

  it "creates a JSON report on completion" do
    @run.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_1.jpg"
    )

    @run.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_1_rotate.jpg"
    )

    @run.complete

    json_report = File.read(@run.json_report_path)

    expect(json_report).to match(/"same":true/)
    expect(json_report).to match(/"same":false/)
  end

  it "creates an HTML report on completion" do
    @run.compare(
      expected: "spec/assets/bug_2.jpg",
      actual: "spec/assets/bug_2.jpg"
    )

    @run.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_1_rotate.jpg"
    )

    @run.complete

    html_report = File.read(@run.html_report_path)

    expect(html_report).to_not match(/bug_2/)
    expect(html_report).to match(/bug_1/)
  end

end
