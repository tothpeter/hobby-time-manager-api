module SeedHelper::Users
  def self.create
    test_users.each do |params|
      params[:password] ||= 123123
      params[:confirmed_at] ||= Time.now
      params[:preferred_working_hours_per_day] ||= 40 # in minutes

      User.create params
    end
  end

  def self.sign_in_my_user
    User.first.authentication_tokens.create!({
      # H14qCcJyTzELR3Zp_oyv
      body: '69d6967da74cf35bf60d8365b80b9b10d8f36d679251bd929634ee227fb3cceb',
      last_used_at: Time.current,
      ip_address: '127.0.0.1',
      user_agent: 'PostmanRuntime/7.1.1'
    })
  end

  private

  def self.test_users
    result = [
      {
        email: 'test@test.com',
        username: 'Peter08',
        access_level: :admin
      },
      {
        email: 'manager@manager.com',
        username: 'Manager01',
        access_level: :manager
      },
      {
        email: 'employee@employee.com',
        username: 'Employee01',
        access_level: :employee
      }
    ]

    (1..10).each do |i|
      result << {
        email: "test#{i}@test.com",
        username: "Test user ##{i}",
      }
    end

    result
  end
end
