class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.text :name
      t.text :redshift_schema
      t.text :salesforce_username

      t.timestamps
    end
  end
end
