# spec/factories/job_specs.rb

FactoryGirl.define do
  factory :job_spec do |f|
    f.name          "factorygirl_job_spec"
    f.association :job_template, factory: :tpl_birst_soap_generic_command
    f.association :job_schedule_group, factory: :job_schedule_group
  end

  factory :tpl_birst_soap_generic_command do |f|
    f.command "list_spaces"
    f.argument_json ""
  end
end
