class CreateTplDevTests < ActiveRecord::Migration
  def change
    create_table :tpl_dev_tests do |t|
      t.string :argument, null: false

      t.timestamps
    end
  end
end
