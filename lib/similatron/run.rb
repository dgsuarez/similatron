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
      comparison = if File.exist?(original)
                     real_comparison(original, generated)
                   else
                     copy_comparison(original, generated)
                   end
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

    def json_report_path
      File.join(run_path, "report.json")
    end

    def html_report_path
      File.join(run_path, "report.html")
    end

    def write_reports
      File.write(html_report_path, to_html)
      File.write(json_report_path, to_json)
    end

    def failed_comparisons
      comparisons.reject(&:same?)
    end

    def overwrite_comparisons
      comparisons.select(&:overwrite?)
    end

    private

    attr_reader :image_engine, :run_path

    def copy_comparison(original, generated)
      FileUtils.cp(generated, original)
      Comparison.new(
        overwrite: true,
        original: original,
        generated: generated,
        score: 0
      )
    end

    def real_comparison(original, generated)
      image_engine.compare(
        original: original,
        generated: generated
      )
    end

  end
end
