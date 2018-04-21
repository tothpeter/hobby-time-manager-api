class Api::Me::TasksController < Api::BaseController
  include JSONAPI::ActsAsResourceController
  include TasksControllerConcern

  authorize_resource

  before_action :authenticate_user!
  before_action :validate_date_filter, only: [:index, :export]

  def export
    tasks = current_user
      .tasks
      .between_dates(params[:start_date], params[:end_date])
      .order(:date, :id)

    date_range = "#{params[:start_date]} - #{params[:end_date]}"

    content = ExportService::Task.export tasks, date_range, current_user

    render html: content.html_safe
  end
end
