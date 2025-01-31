# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
admin = User.create(name: 'Admin User', email: 'admin@example.com', password: 'password', role: :admin)
user = User.create(name: 'Regular User', email: 'user@example.com', password: 'password', role: :user)

project1 = Project.create(name: 'Website Development', start_date: Date.today, duration: 7)
project2 = Project.create(name: 'Mobile App Development', start_date: Date.today - 3, duration: 10)

ProjectsUser.create(user: admin, project: project1)
ProjectsUser.create(user: user, project: project2)
