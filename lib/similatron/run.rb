module Similatron
  class Run

    attr_reader :comparisons

    def start(base_path: "tmp")
      run_id = SecureRandom.urlsafe_base64(8)
      @run_path = File.join(base_path, "run_#{run_id}")

      @engines = [
        ImagemagickComparisonEngine.new(diffs_path: run_path),
        DiffComparisonEngine.new(diffs_path: run_path),
        BinaryDiffComparisonEngine.new(diffs_path: run_path)
      ]

      @comparisons = []
      FileUtils.mkdir_p(run_path)
    end

    def complete
      write_reports
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

    def summary
      return "" if failed_comparisons.empty? && overwrite_comparisons.empty?
      [
        "Similatron report:",
        "#{failed_comparisons.count} failures.",
        "#{overwrite_comparisons.count} new files.",
        "Report may be found in #{html_report_path}"
      ].join("\n")
    end

    def json_report_path
      File.join(run_path, "report.json")
    end

    def html_report_path
      File.join(run_path, "report.html")
    end

    def failed_comparisons
      comparisons.reject(&:same?)
    end

    def overwrite_comparisons
      comparisons.select(&:overwrite?)
    end

    private

    attr_reader :run_path, :engines

    def copy_comparison(original, generated)
      FileUtils.cp(generated, original)
      Comparison.new(
        overwrite: true,
        original: original,
        generated: generated,
        score: 0
      )
    end

    def best_engine(file)
      mime_type = `file --mime -b #{file}`.chomp
      engines.detect { |engine| engine.can_handle_mime?(mime_type) }
    end

    def real_comparison(original, generated)
      engine = best_engine(original)

      engine.compare(
        original: original,
        generated: generated
      )
    end

    def to_json
      comparisons.map(&:as_json).to_json
    end

    def to_html
      template = ERB.new(File.read("lib/assets/report.html.erb"))
      template.result(binding)
    end

    def write_reports
      File.write(html_report_path, to_html)
      File.write(json_report_path, to_json)
    end

  end
end
