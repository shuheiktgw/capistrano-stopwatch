lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-stopwatch'
  spec.version       = '0.0.1'
  spec.authors       = ['Shuhei Kitagawa']
  spec.email         = ['shuhei.kitagawa@gmail.com']

  spec.summary       = %q{Capistrano tasks to measure task execution time}
  spec.description   = %q{Capistrano tasks to measure task execution time}
  spec.homepage      = 'https://github.com/shuheiktgw/capistrano-stopwatch'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '~> 3.0'
end
