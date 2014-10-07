class AddNonNullToBirstSpace < ActiveRecord::Migration
  def up
    change_column :birst_spaces, :space_uuid, :string, :limit => 36, :null => false
  end

  def down
    change_column :birst_spaces, :space_uuid, :string, :limit => 36, :null => true
  end
end
