class AddCustomHeaderToDataSource < ActiveRecord::Migration
  def change
    add_column :data_sources, :custom_header, :text
  end
end
