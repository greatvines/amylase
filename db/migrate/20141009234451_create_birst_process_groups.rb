class CreateBirstProcessGroups < ActiveRecord::Migration
  def change
    create_table :birst_process_groups do |t|
      t.text :name
      t.text :description

      t.timestamps
    end
  end
end
