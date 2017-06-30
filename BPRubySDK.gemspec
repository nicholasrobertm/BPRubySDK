# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'BPRubySDK/version'
require 'rake'

Gem::Specification.new do |spec|
  spec.name          = "BPRubySDK"
  spec.version       = BPRubySDK::VERSION
  spec.authors       = ["Rob"]
  spec.email         = ["robert.nicholas@brightpearl.com"]

  spec.summary       = %q{A Ruby wrapper to the Brightpearl API}
  spec.description   = %q{This gem is a wrapper to the Brightpearl API. To see usage and documentation details please visit https://github.com/xaviarrob/BPRubySDK/}


  spec.homepage      = "http://www.brightpearl.com"
  spec.license       = "MIT"


  #spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #  f.match(%r{^(test|spec|features)/})
  #end
  #spec.files = Dir['lib/   *.rb'] + Dir['bin/*']
  spec.files = ["lib/util/csv_to_json.rb","lib/util/json_to_csv.rb","lib/util/file_log.rb","lib/handlers/response_handler.rb","lib/handlers/request_handler.rb","lib/BPRubySDK.rb","lib/applib/response.rb","lib/applib/connection.rb","lib/applib/request.rb","lib/BPRubySDK/version.rb","lib/applib/request_method.rb","lib/handlers/request_method_handler.rb"]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency 'json', '~> 1.8', '>= 1.8.3'
  spec.add_development_dependency "rspec", "~> 3.0"
end
