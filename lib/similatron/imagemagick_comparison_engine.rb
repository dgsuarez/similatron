module Similatron
  class ImagemagickComparisonEngine < ComparisonEngine

    private

    def default_executable_path
      "compare"
    end

    def command(original, generated, diff_path)
      "#{executable_path} -metric PSNR #{original} #{generated} #{diff_path}"
    end

    def diff(diff_path, exec_result)
      exec_result.status == 1 ? diff_path : nil
    end

    def score(exec_result)
      if exec_result.status == 2
        100
      else
        exec_result.err.to_i
      end
    end

  end
end
