# frozen_string_literal: true

require_relative './lib/moobooks/version'
Gem::Specification.new do |gem|
  gem.name          = Moobooks::NAME
  gem.version       = Moobooks::VERSION
  gem.date          = Time.now.strftime('%F')
  gem.summary       = 'Mooing bots for your friends.'
  gem.description   = Moobooks::DESCRIPTION
  gem.author        = 'Maxine Michalski'
  gem.email         = 'maxine@furfind.net'
  gem.files         = Dir['lib/**/*.rb']
  gem.test_files    = Dir['spec/*.rb']
  gem.require_path  = ['lib']
  gem.executables << 'plushies'
  gem.homepage      = 'https://github.com/maxine-red/moobooks'
  gem.license       = 'GPL-3.0'

  gem.required_ruby_version = '~> 2.3'

  gem.add_development_dependency 'rspec', '~> 3.6'
  gem.add_development_dependency 'rubocop', '= 0.58.0'
  gem.add_development_dependency 'simplecov', '~> 0.16.0'
  gem.add_development_dependency 'yard', '~> 0.9.12'

  gem.add_runtime_dependency 'json', '~> 2.0'
  gem.add_runtime_dependency 'mastodon', '~> 0.1'
  gem.add_runtime_dependency 'moo_ebooks', '~> 1.0'
  gem.add_runtime_dependency 'oauth', '~> 0.5'
  gem.add_runtime_dependency 'pg', '~> 1.0'
  gem.add_runtime_dependency 'twitter', '~> 6.0'
end
