class AddClientToJobSpec < ActiveRecord::Migration
  def change
    add_reference :job_specs, :client, index: true
  end
end
