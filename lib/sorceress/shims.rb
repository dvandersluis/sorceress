path = File.expand_path('shims/', __dir__)
Dir.glob("#{path}/**/*.rb").sort.each { |f| require f }
