$LOAD_PATH << File.expand_path('..', __dir__)
require 'sorceress'

Sorceress::Invocation.new.call
