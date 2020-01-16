require 'sorceress/version'

module Sorceress
  def self.root
    Pathname.new(File.expand_path('..', __dir__))
  end
end

require 'sorceress/cli'
require 'sorceress/config'
