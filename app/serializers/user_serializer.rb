class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :first_name, :last_name, :preferred_working_hours_per_day, :access_level
end
