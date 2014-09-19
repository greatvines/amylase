# -*- encoding: utf-8 -*-
# stub: wasabi 3.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "wasabi"
  s.version = "3.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Daniel Harrington"]
  s.date = "2014-05-04"
  s.description = "A simple WSDL parser"
  s.email = ["me@rubiii.com"]
  s.homepage = "https://github.com/savonrb/wasabi"
  s.licenses = ["MIT"]
  s.rubyforge_project = "wasabi"
  s.rubygems_version = "2.3.0"
  s.summary = "A simple WSDL parser"

  s.installed_by_version = "2.3.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httpi>, ["~> 2.0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_runtime_dependency(%q<mime-types>, ["< 2.0.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<rspec>, ["~> 2.10"])
    else
      s.add_dependency(%q<httpi>, ["~> 2.0"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_dependency(%q<mime-types>, ["< 2.0.0"])
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<rspec>, ["~> 2.10"])
    end
  else
    s.add_dependency(%q<httpi>, ["~> 2.0"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
    s.add_dependency(%q<mime-types>, ["< 2.0.0"])
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<rspec>, ["~> 2.10"])
  end
end
