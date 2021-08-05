Gem::Specification.new do |spec|
  spec.name         = "paster"
  spec.version      = "0.0.3"
  spec.summary      = "universal asynchronous pastebin CLI"

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/paster"}

  spec.add_dependency "clipboard"
  spec.add_dependency "nethttputils", "~>0.4.1.3"
  spec.add_dependency "github-linguist"
  spec.add_dependency "oga"
  spec.add_dependency "tty-prompt"

  spec.files        = %w{ LICENSE paster.gemspec bin/paster lib/paster.rb lib/genshi.txt lib/pygments.txt }
  spec.bindir       = "bin"
  spec.executable   = "paster"
end
