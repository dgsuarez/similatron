module Similatron
  class BinaryDiffComparisonEngine < ComparisonEngine

    private

    def command(original, generated, _diff_path)
      "#{executable_path} #{original} #{generated}"
    end

    def default_executable_path
      "diff"
    end

    def diff(_diff_path, _exec_result)
      nil
    end

    def score(exec_result)
      exec_result.status
    end

  end
end
