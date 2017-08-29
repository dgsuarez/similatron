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

  end
end
