require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "database_monitor"
  gem.homepage = "http://github.com/pedroaxl/database_monitor"
  gem.license = "MIT"
  gem.summary = %Q{Simple daemon to compare DB queries and notify by email.}
  gem.description = %Q{Simple daemon to compare DB queries and notify by email. Check README for more information} 
  gem.email = "pedro@softa.com.br"
  gem.authors = ["Pedro Axelrud"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency "sequel", "~> 3.19"
  gem.add_runtime_dependency "pony", "~> 1.0"
  gem.add_development_dependency "sqlite3", "~> 1.3"

end
Jeweler::RubygemsDotOrgTasks.new

puts "Ensure you have the database adapter gem you need installed."

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "new #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
