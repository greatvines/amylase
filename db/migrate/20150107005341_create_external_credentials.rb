class CreateExternalCredentials < ActiveRecord::Migration
  def change
    create_table :external_credentials do |t|
      t.text :name, :null => false
      t.text :description
      t.text :username
      t.text :password

      t.timestamps
    end

    add_index :external_credentials, :name, unique: true
  end
end
