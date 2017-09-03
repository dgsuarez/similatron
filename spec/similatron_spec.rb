require 'spec_helper'

describe Similatron do

  it "runs without needing to initialize anything" do
    Similatron.compare(
      original: "spec/assets/bug_1.jpg",
      generated: "spec/assets/bug_1.jpg"
    )

    Similatron.complete
  end

end
