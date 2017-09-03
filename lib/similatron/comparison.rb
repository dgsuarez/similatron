module Similatron
  class Comparison

    attr_reader :original, :generated, :diff, :score

    def initialize(original:, generated:, score:, diff: nil)
      @original = original
      @generated = generated
      @diff = diff
      @score = score
    end

    def same?
      @score.zero?
    end

    def raise_when_different
      return if same?

      message_parts = [
        "Found #{generated} different from #{original}\n",
        "Score: #{score}"
      ]
      message_parts << "\nDiff in #{diff}" if diff

      raise StandardError, message_parts.join
    end

    def as_json
      {
        original: original,
        generated: generated,
        diff: diff,
        score: score,
        same: !!same? # rubocop:disable Style/DoubleNegation
      }
    end

  end
end
