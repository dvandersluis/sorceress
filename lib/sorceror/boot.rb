$LOAD_PATH << File.expand_path('..', __dir__)
require 'sorceror'

cli = Sorceror::CLI.new
cli.announce('Hello World!')
