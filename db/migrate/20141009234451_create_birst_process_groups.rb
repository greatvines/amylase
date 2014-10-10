class CreateBirstProcessGroups < ActiveRecord::Migration
  def change
    create_table :birst_process_groups do |t|
      t.text :name, :null => false
      t.text :description

      t.timestamps
    end

    add_index :birst_process_groups, :name, unique: true

  end
end
