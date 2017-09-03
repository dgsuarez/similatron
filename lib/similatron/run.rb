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

      comparison = image_engine.compare(
        original: original,
        generated: generated
      )
      comparisons << comparison

      comparison
    end

    def compare!(original:, generated:)
      comparison = compare(original: original, generated: generated)
      comparison.raise_when_different
    end

    def to_json
      comparisons.map(&:as_json).to_json
    end

    def to_html
      template = ERB.new(File.read("lib/assets/report.html.erb"))
      template.result(binding)
    end

    def failed_comparisons
      comparisons.reject(&:same?)
    end

    private

    attr_reader :image_engine

    def force_generation_if_needed(original, generated)
      FileUtils.cp(generated, original) unless File.exist?(original)
    end

  end
end
