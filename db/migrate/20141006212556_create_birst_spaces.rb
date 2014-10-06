class CreateBirstSpaces < ActiveRecord::Migration
  def change
    create_table :birst_spaces do |t|
      t.text :name
      t.references :client, index: true
      t.text :type
      t.string :space_id

      t.timestamps
    end
  end
end
