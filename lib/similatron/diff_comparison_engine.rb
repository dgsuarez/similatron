module Similatron
  class DiffComparisonEngine < ComparisonEngine

    def can_handle_mime?(mime_type)
      mime_type !~ /charset=binary/
    end

    private

    def command(expected, actual, _diff_path)
      "#{executable_path} #{expected} #{actual}"
    end

    def default_executable_path
      "diff"
    end

    def diff_extension
      "diff"
    end

    def diff(diff_path, exec_result)
      if exec_result.status != 0
        File.write(diff_path, exec_result.out)
        diff_path
      else # rubocop:disable Style/EmptyElse
        nil
      end
    end

    def score(exec_result)
      return 0 if exec_result.status.zero?

      lines = exec_result.out.split("\n")
      lines.grep(/^>|</).size / 2.0
    end

  end
end
