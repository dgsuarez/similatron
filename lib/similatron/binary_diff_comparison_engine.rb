module Similatron
  class BinaryDiffComparisonEngine < ComparisonEngine

    def can_handle_mime?(_)
      true
    end

    private

    def command(expected, actual, _diff_path)
      "#{executable_path} #{expected} #{actual}"
    end

    def default_executable_path
      "diff"
    end

    def diff_extension
      "notused"
    end

    def diff(_exec_result)
      nil
    end

    def score(exec_result)
      exec_result.status
    end

  end
end
