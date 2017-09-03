require 'spec_helper'

describe Similatron do

  it "runs without needing to initialize anything" do
    Similatron.compare(
      expected: "spec/assets/bug_1.jpg",
      actual: "spec/assets/bug_1.jpg"
    )

    Similatron.complete
  end

end
