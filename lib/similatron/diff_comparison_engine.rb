module Similatron
  class DiffComparisonEngine

    def initialize(executable_path: nil, diffs_path:)
      @executable_path = executable_path || "diff"
      @diffs_path = diffs_path
    end

    def compare(original:, generated:)
      diff_path = next_diff_path

      command = "#{executable_path} #{original} #{generated}"
      exec_output, = Open3.capture3(command)

      Comparison.new(
        original: original,
        generated: generated,
        score: score(exec_output),
        diff: diff(diff_path, exec_output)
      )
    end

    private

    attr_reader :executable_path, :diffs_path, :diff_index

    def next_diff_path
      @diff_index ||= 0
      @diff_index += 1
      File.join(diffs_path, "diff_#{diff_index}.diff")
    end

    def diff(diff_path, exec_output)
      if score(exec_output) != 0
        File.write(diff_path, exec_output)
        diff_path
      else # rubocop:disable Style/EmptyElse
        nil
      end
    end

    def score(exec_output)
      return 0 if exec_output.empty?
      lines = exec_output.split("\n")

      lines.grep(/^>|</).size / 2.0
    end

  end
end
