module SeedHelper::Tasks
  def self.create
    create_tasks tasks_params_for_me
    create_tasks tasks_params_for_others
  end

  private

  def self.create_tasks tasks_params
    tasks_params.each do |params|
      Task.create params
    end
  end

  def self.tasks_params_for_me
    result = []

    2.times do |i|
      result << {
        user_id: 1,
        title: "Task with long desc",
        description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        date: Date.yesterday,
        duration: 10 # minutes
      }
    end


    result << {
      user_id: 1,
      title: "Task with line breaks in desc",
      description: "Lorem ipsum dolor sit amet,\n\rconsectetur adipisicing elit, sed do\n\r\n\reiusmod",
      date: Date.yesterday,
      duration: 10 # minutes
    }

    3.times do |i|
      result << {
        user_id: 1,
        title: "Test task##{i} yesterday",
        description: "Description of test task##{i}",
        date: Date.yesterday,
        duration: 1 # minutes
      }
    end

    4.times do |i|
      result << {
        user_id: 1,
        title: "Test task##{i} today",
        description: "Description of test task##{i}",
        date: Date.today,
        duration: 10 # minutes
      }
    end


    3.times do |i|
      result << {
        user_id: 1,
        title: "Test task##{i} tomorrow",
        description: "Description of test task##{i}",
        date: Date.today + 1,
        duration: 10 # minutes
      }
    end

    2.times do |i|
      result << {
        user_id: 1,
        title: "Test task##{i} yesterday",
        description: "Description of test task##{i}",
        date: Date.yesterday,
        duration: 10 # minutes
      }
    end

    result
  end


  def self.tasks_params_for_others
    result = []

    3.times do |i|
      result << {
        user_id: 2,
        title: "Test task##{i} for manager (yesterday)",
        description: "Description of test task##{i}",
        date: (Date.yesterday),
        duration: 1 # minutes
      }
    end

    3.times do |i|
      result << {
        user_id: 3,
        title: "Test task##{i} for employee (yesterday)",
        description: "Description of test task##{i}",
        date: (Date.yesterday),
        duration: 1 # minutes
      }
    end

    result
  end
end
