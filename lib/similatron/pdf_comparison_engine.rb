module Similatron
  class PdfComparisonEngine < ComparisonEngine

    def can_handle_mime?(mime_type)
      mime_type =~ %r{application/pdf}
    end

    def compare(expected:, actual:)
      jpg_comparison = jpg_compare(expected: expected, actual: actual)

      Comparison.new(
        expected: expected,
        actual: actual,
        score: jpg_comparison.score,
        diff: jpg_comparison.diff
      )
    end

    private

    def image_magick_engine
      ImagemagickComparisonEngine.new(
        executable_path: given_executable_path,
        diffs_path: diffs_path
      )
    end

    def jpg_compare(expected:, actual:)
      Dir.mktmpdir do |dir|
        jpg_expected = "#{dir}/expected.jpg"
        jpg_actual = "#{dir}/actual.jpg"

        convert(expected, jpg_expected)
        convert(actual, jpg_actual)

        image_magick_engine.compare(
          expected: jpg_expected,
          actual: jpg_actual
        )
      end
    end

    def convert(pdf, jpg)
      `convert -append #{pdf} #{jpg}`
    end

  end
end
