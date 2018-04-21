module ExportService
  class Task
    def self.export tasks, date_range, user
      groups = group_tasks tasks, user.preferred_working_hours_per_day

      template = File.read 'app/views/exports/tasks.html.erb'

      ERB.new(template, 0, '', '@html').result(binding)
    end

    private

    def self.group_tasks tasks, preferred_working_hours
      groups = []

      tasks.group_by(&:date).each do |date, grouped_tasks|
        groups << create_group(date, grouped_tasks, preferred_working_hours)
      end

      groups
    end

    def self.create_group date, tasks, preferred_working_hours
      total_time = tasks.inject(0){|sum, t| sum + t.duration }
      OpenStruct.new({
        date: date,
        total_time: total_time,
        under_preferred_working_hours: total_time < preferred_working_hours,
        tasks: tasks
      })
    end

    def self.format_time minutes
      hours, minutes = minutes.divmod 60

      result = []

      result << "#{hours}h" if hours > 0
      result << "#{minutes}m" if minutes > 0

      result.join ' '
    end
  end
end
