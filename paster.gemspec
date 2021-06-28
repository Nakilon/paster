Gem::Specification.new do |spec|
  spec.name         = "paster"
  spec.version      = "0.0.0"
  spec.summary      = "universal asynchronous pastebin CLI"

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/paster"}

  spec.files        = %w{ LICENSE paster.gemspec lib/paster.rb bin/paster.rb }

  spec.add_dependency "nethttputils", "~>0.4.1.3"
  spec.add_dependency "github-linguist"
  spec.add_dependency "oga"
  spec.add_dependency "tty-prompt"
end
