FactoryBot.define do
  factory :task do
    name { "Sample Task" }
    duration { 5 }  # Set a default duration, change as needed
    start_time { "2025-01-01 09:00:00" }  # Default start time, adjust as needed
    end_time { "2025-01-01 14:00:00" }    # Default end time, adjust as needed
    project  # Assuming that a task belongs to a project
  end
end