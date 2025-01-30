class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.date :start_date
      t.integer :duration # Duration in days

      t.timestamps
    end
  end
end
