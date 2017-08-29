module Similatron
  class ImagemagickComparisonEngine

    def initialize(executable_path: nil, diffs_path: "tmp/")
      @executable_path = executable_path || "compare"
      @diffs_path = diffs_path
      @diff_index = 0
    end

    def compare(original:, generated:)
      diff_path = next_diff_path
      exec_output = `#{executable_path} -metric PSNR #{original} #{generated} #{diff_path}`

      Comparison.new(
        original: original,
        generated: generated,
        score: score(exec_output),
        diff: diff(diff_path)
      )
    end

    private

    attr_reader :executable_path, :diffs_path, :diff_index

    def next_diff_path
      FileUtils.mkdir_p(diffs_path)
      File.join(diffs_path, "diff_#{diff_index}.jpg")
    end

    def last_run_failed?
      $CHILD_STATUS.exitstatus == 2
    end

    def last_run_eql?
      $CHILD_STATUS.exitstatus.zero?
    end

    def diff(diff_path)
      last_run_eql? ? diff_path : nil
    end

    def score(output)
      if last_run_failed?
        100
      else
        output.to_i
      end
    end

  end
end
