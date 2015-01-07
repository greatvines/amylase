class CreateExternalCredentials < ActiveRecord::Migration
  def change
    create_table :external_credentials do |t|
      t.text :name
      t.text :description
      t.text :username
      t.text :password

      t.timestamps
    end
  end
end
