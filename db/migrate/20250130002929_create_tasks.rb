class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.integer :duration # Duration in minutes

      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
