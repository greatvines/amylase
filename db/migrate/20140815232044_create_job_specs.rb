class CreateJobSpecs < ActiveRecord::Migration
  def change
    create_table :job_specs do |t|
      t.string :name
      t.boolean    :enabled, default: false
      t.references :job_template, polymorphic: true

      t.timestamps
    end
  end
end
