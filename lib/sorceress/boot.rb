$LOAD_PATH << File.expand_path('..', __dir__)
require 'sorceress'

include Sorceress::CLI # rubocop:disable Style/MixinUsage
announce('Hello World!')
