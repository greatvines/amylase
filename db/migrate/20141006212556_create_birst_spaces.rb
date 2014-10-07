class CreateBirstSpaces < ActiveRecord::Migration
  def change
    create_table :birst_spaces do |t|
      t.text :name, :null => false
      t.references :client, index: true
      t.text :space_type
      t.string :space_uuid, limit: 36

      t.timestamps
    end

    add_index :birst_spaces, :name, unique: true

  end
end
