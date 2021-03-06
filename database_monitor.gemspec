# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{database_monitor}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pedro Axelrud"]
  s.date = %q{2011-01-31}
  s.default_executable = %q{database_monitor}
  s.description = %q{Simple daemon to compare DB queries and notify by email. Check README for more information}
  s.email = %q{pedro@softa.com.br}
  s.executables = ["database_monitor"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README",
    "Rakefile",
    "VERSION",
    "bin/database_monitor",
    "config.sample.yml",
    "database_monitor.gemspec",
    "lib/daemon.rb",
    "lib/monitor.rb",
    "test/helper.rb",
    "test/test_monitor.rb"
  ]
  s.homepage = %q{http://github.com/pedroaxl/database_monitor}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Simple daemon to compare DB queries and notify by email.}
  s.test_files = [
    "test/helper.rb",
    "test/test_monitor.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sequel>, ["~> 3.19"])
      s.add_runtime_dependency(%q<pony>, ["~> 1.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3"])
      s.add_runtime_dependency(%q<sequel>, ["~> 3.19"])
      s.add_runtime_dependency(%q<pony>, ["~> 1.0"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3"])
    else
      s.add_dependency(%q<sequel>, ["~> 3.19"])
      s.add_dependency(%q<pony>, ["~> 1.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3"])
      s.add_dependency(%q<sequel>, ["~> 3.19"])
      s.add_dependency(%q<pony>, ["~> 1.0"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3"])
    end
  else
    s.add_dependency(%q<sequel>, ["~> 3.19"])
    s.add_dependency(%q<pony>, ["~> 1.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3"])
    s.add_dependency(%q<sequel>, ["~> 3.19"])
    s.add_dependency(%q<pony>, ["~> 1.0"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3"])
  end
end

