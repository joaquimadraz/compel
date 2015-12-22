# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'compel/version'

Gem::Specification.new do |gem|
  gem.name          = 'compel'
  gem.version       = Compel::VERSION
  gem.authors       = ['Joaquim Adráz']
  gem.email         = ['joaquim.adraz@gmail.com']
  gem.description   = %q{Compel}
  gem.summary       = %q{Ruby hash coercion and validation}
  gem.homepage      = 'https://github.com/joaquimadraz/compel'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec', '~> 3.2'
  gem.add_development_dependency 'rake', '~> 0'
  gem.add_development_dependency 'pry', '~> 0'
end
