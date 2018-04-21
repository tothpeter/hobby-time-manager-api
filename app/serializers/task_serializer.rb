class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :date, :duration
  has_one :user
end
