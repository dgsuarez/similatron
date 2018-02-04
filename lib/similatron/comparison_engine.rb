module Similatron
  class ComparisonEngine
    def initialize(executable_path: nil, diffs_path:)
      @given_executable_path = executable_path
      @diffs_path = diffs_path
    end

    def compare(expected:, actual:)
      increase_diff_index

      command = command(expected, actual, diff_path)

      exec_result = run(command)

      Comparison.new(
        expected: expected,
        actual: actual,
        score: score(exec_result),
        diff: diff(exec_result)
      )
    end

    protected

    attr_reader :diffs_path, :diff_index, :given_executable_path

    def run(command)
      exec_info = Open3.capture3(command)
      Open3Result.new(*exec_info)
    end

    def increase_diff_index
      @diff_index ||= 0
      @diff_index += 1
    end

    def diff_path
      File.join(diffs_path, "diff_#{diff_index}.#{diff_extension}")
    end

    def executable_path
      default_executable_path || given_executable_path
    end

    class Open3Result
      attr_reader :out, :err, :status

      def initialize(out, err, status)
        @out = out
        @err = err
        @status = status.exitstatus

        p "OUT", @out, "ERR", @err, "STATUS", @status
      end
    end

  end
end
