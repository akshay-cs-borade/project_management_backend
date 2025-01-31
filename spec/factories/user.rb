# spec/factories/users.rb

FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      password { 'password123' }
      password_confirmation { 'password123' }
      # Add any other necessary fields, such as:
      # first_name { "John" }
      # last_name { "Doe" }
  
      # If you're using Devise for authentication, these fields are usually sufficient.
      # If your User model has more attributes, include them here.
    end
  end
  