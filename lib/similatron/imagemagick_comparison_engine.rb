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
