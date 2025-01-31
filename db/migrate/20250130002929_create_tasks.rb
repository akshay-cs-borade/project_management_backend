class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.integer :duration # Duration in minutes

      t.references :project
      t.references :user

      t.timestamps
    end
  end
end
