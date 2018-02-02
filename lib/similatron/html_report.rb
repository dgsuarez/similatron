module Similatron
  class HtmlReport

    attr_reader :run

    def initialize(run)
      @run = run
    end

    def render
      template_path = File.join(Similatron.lib_path, "assets/report.html.erb")
      template = ERB.new(File.read(template_path))
      template.result(binding)
    end

    def css_styles
      ["normalize.css", "skeleton.css"].map do |file|
        css_path = File.join(Similatron.lib_path, "assets/Skeleton-2.0.4/css", file)
        File.read(css_path)
      end
    end

  end
end
