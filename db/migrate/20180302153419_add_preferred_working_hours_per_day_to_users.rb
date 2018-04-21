class AddPreferredWorkingHoursPerDayToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :preferred_working_hours_per_day, :integer
  end
end
