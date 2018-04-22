require_relative 'seed_helper'

tables_to_truncate = %w(tasks authentication_tokens users)

ActiveRecord::Base.connection.execute("TRUNCATE #{tables_to_truncate.join(',')} RESTART IDENTITY")

SeedHelper::Users.create
SeedHelper::Users.sign_in_my_user
SeedHelper::Tasks.create
