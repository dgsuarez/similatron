module Similatron
  class ComparisonEngine
    def initialize(executable_path: nil, diffs_path:)
      @executable_path = executable_path || "diff"
      @diffs_path = diffs_path
    end

    def compare(expected:, actual:)
      diff_path = next_diff_path

      command = command(expected, actual, diff_path)

      exec_result = run(command)

      Comparison.new(
        expected: expected,
        actual: actual,
        score: score(exec_result),
        diff: diff(diff_path, exec_result)
      )
    end

    protected

    attr_reader :diffs_path, :diff_index

    def run(command)
      exec_info = Open3.capture3(command)
      Open3Result.new(*exec_info)
    end

    def next_diff_path
      @diff_index ||= 0
      @diff_index += 1

      File.join(diffs_path, "diff_#{diff_index}.#{diff_extension}")
    end

    def executable_path
      default_executable_path || @executable_path
    end

    class Open3Result
      attr_reader :out, :err, :status

      def initialize(out, err, status)
        @out = out
        @err = err
        @status = status.exitstatus
      end
    end

  end
end
