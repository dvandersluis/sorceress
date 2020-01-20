require 'sorceress/version'

module Sorceress
  def self.root
    Pathname.new(File.expand_path('..', __dir__))
  end
end

require 'sorceress/shims'
require 'sorceress/spells'

require 'sorceress/cli'
require 'sorceress/dependency'
require 'sorceress/spellbook'
