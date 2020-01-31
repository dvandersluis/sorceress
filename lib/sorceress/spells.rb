require 'spells/run_script'

path = File.expand_path('../spells/', __dir__)
Dir.glob("#{path}/**/*.rb").sort.each { |f| require f }
