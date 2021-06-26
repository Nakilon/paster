Gem::Specification.new do |spec|
  spec.name         = "paster"
  spec.version      = "0.0.0"
  spec.summary      = "universal asynchronous pastebin CLI"

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/paster"}

  spec.files        = %w{ LICENSE paster.gemspec lib/paster.rb bin/paster.rb }

  spec.add_dependency "nethttputils"
  spec.add_dependency "github-linguist"
end
