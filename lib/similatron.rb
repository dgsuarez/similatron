require "English"
require 'securerandom'
require 'open3'

require "similatron/version"
require "similatron/comparison"
require "similatron/imagemagick_comparison_engine"

module Similatron

  class Run

    def initialize
      run_id = SecureRandom.urlsafe_base64(8)
      @image_engine = ImagemagickComparisonEngine.new(run_id: run_id)
    end

    def compare_images(original:, generated:)
      FileUtils.cp(original, generated) unless File.exist?(original)

      @image_engine.compare(
        original: original,
        generated: generated
      )
    end

    private

    attr_reader :image_engine

  end
end
