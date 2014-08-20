class CreateTplBirstDuplicateSpace < ActiveRecord::Migration
  def change
    create_table :tpl_birst_duplicate_spaces do |t|
      t.string  :from_space_id_str #placeholder for a real reference
      t.string  :to_space_name
      t.boolean :with_membership
      t.boolean :with_data
      t.boolean :with_datastore

      t.timestamps
    end
  end
end
