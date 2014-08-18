class CreateTplBirstSoapGenericCommands < ActiveRecord::Migration
  def change
    create_table :tpl_birst_soap_generic_commands do |t|
      t.string :command
      t.string :argument_json

      t.timestamps
    end
  end
end
