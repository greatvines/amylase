# spec/factories/tpl_birst_soap_generic_commands

FactoryGirl.define do
  factory :tpl_birst_soap_generic_command do
    command "list_spaces"
    argument_json ""
  end
end
