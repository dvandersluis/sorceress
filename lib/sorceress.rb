require 'sorceress/version'
require 'forwardable'
require 'pathname'

module Sorceress
  class << self
    extend Forwardable

    def_delegators :context, :spellbook

    def root
      Pathname.new(File.expand_path('..', __dir__))
    end

    def context
      Context.instance
    end
  end
end

require 'sorceress/shims'
require 'sorceress/errors'

require 'sorceress/cli'
require 'sorceress/context'
require 'sorceress/dependency'
require 'sorceress/dependency/ruby'
require 'sorceress/invocation'
require 'sorceress/spell'
require 'sorceress/spellbook'

require 'sorceress/spells'
