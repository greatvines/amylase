# -*- encoding: utf-8 -*-
# stub: jquery-datatables-rails 2.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "jquery-datatables-rails"
  s.version = "2.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Robin Wenglewski"]
  s.date = "2014-08-19"
  s.description = ""
  s.email = ["robin@wenglewski.de"]
  s.homepage = "https://github.com/rweng/jquery-datatables-rails"
  s.rubygems_version = "2.2.2"
  s.summary = "jquery datatables for rails"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jquery-rails>, [">= 0"])
      s.add_runtime_dependency(%q<sass-rails>, [">= 0"])
    else
      s.add_dependency(%q<jquery-rails>, [">= 0"])
      s.add_dependency(%q<sass-rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<jquery-rails>, [">= 0"])
    s.add_dependency(%q<sass-rails>, [">= 0"])
  end
end
