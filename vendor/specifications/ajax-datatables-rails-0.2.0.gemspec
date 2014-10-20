# -*- encoding: utf-8 -*-
# stub: ajax-datatables-rails 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ajax-datatables-rails"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Joel Quenneville"]
  s.date = "2014-06-19"
  s.description = "A gem that simplifies using datatables and hundreds of records via ajax"
  s.email = ["joel.quenneville@collegeplus.org"]
  s.homepage = ""
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.2.2"
  s.summary = "A wrapper around datatable's ajax methods that allow synchronization with server-side pagination in a rails app"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.1"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<generator_spec>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 3.1.0"])
    else
      s.add_dependency(%q<railties>, [">= 3.1"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<generator_spec>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 3.1.0"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.1"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<generator_spec>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 3.1.0"])
  end
end
