class AdjustLengthOfStrings < ActiveRecord::Migration
  def up
    change_column :tpl_birst_duplicate_spaces, :from_space_id_str, :string, :limit => 36
    change_column :tpl_birst_soap_generic_commands, :command, :string, :limit => 80
    change_column :tpl_birst_soap_generic_commands, :argument_json, :string, :limit => 1024
  end

  def down
    change_column :tpl_birst_duplicate_spaces, :from_space_id_str, :string, :limit => 255
    change_column :tpl_birst_soap_generic_commands, :command, :string, :limit => 255
    change_column :tpl_birst_soap_generic_commands, :argument_json, :string, :limit => 255
  end
end
