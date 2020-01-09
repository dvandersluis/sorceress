$LOAD_PATH << File.expand_path('..', __dir__)
require 'sorceress'

cli = Sorceress::CLI.new
cli.announce('Hello World!')
