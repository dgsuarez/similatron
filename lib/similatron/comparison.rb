module Similatron
  class Comparison

    attr_reader :expected, :actual, :diff, :score

    def initialize(expected:, actual:, score:, diff: nil, overwrite: nil)
      @expected = expected
      @actual = actual
      @diff = diff
      @score = score
      @overwrite = overwrite
    end

    def same?
      @score.zero?
    end

    def overwrite?
      @overwrite
    end

    def raise_when_different
      return if same?

      message_parts = [
        "Found #{actual} different from #{expected}\n",
        "Score: #{score}"
      ]
      message_parts << "\nDiff in #{diff}" if diff

      raise StandardError, message_parts.join
    end

    def as_json
      {
        expected: expected,
        actual: actual,
        diff: diff,
        score: score,
        same: !!same?, # rubocop:disable Style/DoubleNegation
        overwrite: !!overwrite? # rubocop:disable Style/DoubleNegation
      }
    end

  end
end
