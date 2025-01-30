class CreateProjectsUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :projects_users do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
