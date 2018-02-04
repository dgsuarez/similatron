module Similatron
  class ImagemagickComparisonEngine < ComparisonEngine

    def can_handle_mime?(mime_type)
      mime_type =~ /image/
    end

    private

    def default_executable_path
      "compare"
    end

    def diff_extension
      "jpg"
    end

    def command(expected, actual, diff_path)
      "#{executable_path} -metric PSNR #{expected} #{actual} #{diff_path}"
    end

    def diff(exec_result)
      could_calculate_score?(exec_result) ? diff_path : nil
    end

    def score(exec_result)
      if could_calculate_score?(exec_result)
        exec_result.err.to_i
      elsif exec_result.status.zero?
        0
      else
        100
      end
    end

    def could_calculate_score?(exec_result)
      exec_result.err =~ /^[\.0-9]+$/
    end

  end
end
