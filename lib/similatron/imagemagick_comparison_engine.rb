module Similatron
  class ImagemagickComparisonEngine

    def initialize(executable_path: nil, diffs_path: "tmp/", run_id:)
      @executable_path = executable_path || "compare"
      @diffs_path = diffs_path
      @diff_index = 0
      @run_id = run_id
    end

    def compare(original:, generated:)
      diff_path = next_diff_path

      command = "#{executable_path} -metric PSNR #{original} #{generated} #{diff_path}"
      _, exec_output, exec_status = Open3.capture3(command)

      Comparison.new(
        original: original,
        generated: generated,
        score: score(exec_output, exec_status),
        diff: diff(diff_path, exec_status)
      )
    end

    private

    attr_reader :executable_path, :diffs_path, :diff_index, :run_id

    def next_diff_path
      FileUtils.mkdir_p(diffs_path)
      @diff_index += 1
      File.join(diffs_path, "diff_#{run_id}_#{diff_index}.jpg")
    end

    def diff(diff_path, exec_status)
      exec_status.exitstatus == 1 ? diff_path : nil
    end

    def score(output, exec_status)
      if exec_status.exitstatus == 2
        100
      else
        output.to_i
      end
    end

  end
end
