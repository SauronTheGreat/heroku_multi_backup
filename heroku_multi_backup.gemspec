# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heroku_multi_backup/version'

Gem::Specification.new do |spec|
  spec.name          = "heroku_multi_backup"
  spec.version       = HerokuMultiBackup::VERSION
  spec.authors       = ["The Dark Lord"]
  spec.email         = ["contactme@rushabhhathi.com"]
  spec.summary       = %q{A Gem to create backups of multiple heroku apps and upload it to the specified Amazon S3 bucket.}
  spec.description   = %q{It automates the backup process of heroku and uploads the backup file to the amazon s3 cloud servers.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  # spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_runtime_dependency "rake"
  spec.add_runtime_dependency "pg"
  spec.add_runtime_dependency "heroku", ">= 3.28.6", "<= 3.32"
  spec.add_runtime_dependency "aws-sdk",  '~> 2'


end
