# frozen_string_literal: true

require_relative "lib/pg_query_optimizer/version"

Gem::Specification.new do |spec|
  spec.name = "pg_query_optimizer"
  spec.version = PgQueryOptimizer::VERSION
  spec.authors = ["jana AKA JanSha"]
  spec.email = ["shanmugamjanarthan24@gmail.com"]

  spec.summary       = %q{Optimizes PostgreSQL queries for better performance by enabling parallel execution.}
  spec.description   = %q{pg_query_optimizer is a gem that improving the performance of complex queries specifically desingned for postgress database. This query significantly improves query execution times for large datasets.}
  spec.homepage      = "https://github.com/janarthanan-shanmugam/pg_query_optimizer"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] =  spec.homepage 
  spec.metadata["changelog_uri"] =  spec.homepage

  spec.files         = Dir["lib/**/*"]
  spec.require_paths = ["lib"]

  #  # Specify which files should be added to the gem when it is released.
  # # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # gemspec = File.basename(__FILE__)
  # spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
  #   ls.readlines("\x0", chomp: true).reject do |f|
  #     (f == gemspec) ||
  #       f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
  #   end
  # end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  
  spec.add_dependency "pg", ">= 0.21"
  spec.add_dependency "rails", ">= 5.0"
end
