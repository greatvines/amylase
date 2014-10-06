class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.text :name, :null => false
      t.text :redshift_schema
      t.text :salesforce_username

      t.timestamps
    end

    add_index :clients, :name, unique: true

  end
end
