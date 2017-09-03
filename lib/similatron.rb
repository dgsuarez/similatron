require "English"
require 'securerandom'
require 'open3'
require 'json'
require 'erb'

require "similatron/version"
require "similatron/comparison"
require "similatron/comparison_engine"
require "similatron/imagemagick_comparison_engine"
require "similatron/diff_comparison_engine"
require "similatron/binary_diff_comparison_engine"
require "similatron/run"

module Similatron
  def self.compare(*args)
    run.compare!(*args)
  end

  def self.complete
    run.complete
    puts run.summary
  end

  def self.run
    @run ||= begin
               run = Run.new
               run.start
               run
             end
  end
end
