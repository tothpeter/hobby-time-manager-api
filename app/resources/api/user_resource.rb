class Api::UserResource < JSONAPI::Resource
  attributes :email, :username, :first_name, :last_name, :preferred_working_hours_per_day, :access_level

  def self.records options = {}
    context = options[:context]

    User.where.not(id: context[:current_user].id)
  end

  filters :username, :email

  filter :username,
    verify: ->(values, context) {
      username = values[0].strip.downcase

      raise JSONAPI::Exceptions::InvalidFilterValue.new(:username, values[0]) if username.length < 3

      username
    },
    apply: ->(records, value, _options) {
      records.where('lower(users.username) like (?)', "%#{value}%")
    }

  filter :email,
    verify: ->(values, context) {
      email = values[0].strip.downcase

      raise JSONAPI::Exceptions::InvalidFilterValue.new(:email, values[0]) if email.length < 3

      email
    },
    apply: ->(records, value, _options) {
      records.where('lower(users.email) like (?)', "%#{value}%")
    }
end
