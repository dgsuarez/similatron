module Similatron
  class Run

    attr_reader :comparisons

    def initialize
      run_id = SecureRandom.urlsafe_base64(8)
      @image_engine = ImagemagickComparisonEngine.new(run_id: run_id)
      @comparisons = []
    end

    def compare(original:, generated:)
      force_generation_if_needed(original, generated)

      comparisons << image_engine.compare(
        original: original,
        generated: generated
      )
    end

    private

    attr_reader :image_engine

    def force_generation_if_needed(original, generated)
      FileUtils.cp(original, generated) unless File.exist?(generated)
    end

  end
end
