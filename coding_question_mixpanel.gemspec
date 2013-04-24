Gem::Specification.new do |s|
  s.name = "coding_question_mixpanel"
  s.version = "0.0.1"
  s.summary = "Coding question for mixpanel"
  s.authors = [ "Jeremy Deininger" ]
  s.email = [ "jeremydeininger@gmail.com" ]
  s.bindir = "bin"
  s.files = Dir.glob("lib/**/*.rb") + \
    Dir.glob("spec/**/*.rb")
  s.add_dependency("data_mapper", ">=0")
  s.add_dependency("dm-mysql-adapter", ">=0")
  s.add_dependency("trollop", ">=0")
  s.add_development_dependency("rake", ">=0")
  s.add_development_dependency("rspec", ">=0")
end
