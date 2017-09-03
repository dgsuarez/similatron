module Similatron
  class Run

    attr_reader :comparisons

    def initialize(base_path: "tmp")
      run_id = SecureRandom.urlsafe_base64(8)
      @run_path = File.join(base_path, "run_#{run_id}")
      @image_engine = ImagemagickComparisonEngine.new(diffs_path: run_path)

      @comparisons = []
      FileUtils.mkdir_p(run_path)
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

    def write_reports
      File.write(File.join(run_path, "report.html"), to_html)
      File.write(File.join(run_path, "report.json"), to_json)
    end

    def failed_comparisons
      comparisons.reject(&:same?)
    end

    private

    attr_reader :image_engine, :run_path

    def force_generation_if_needed(original, generated)
      FileUtils.cp(generated, original) unless File.exist?(original)
    end

  end
end
