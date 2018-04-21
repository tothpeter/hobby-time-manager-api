class Api::TasksController < Api::BaseController
  include JSONAPI::ActsAsResourceController
  include TasksControllerConcern

  before_action :authenticate_user!
  before_action :authorise_user!
  before_action :validate_date_filter, only: [:index, :export]
  before_action :validate_user_filter, only: [:index, :export]

  authorize_resource

  def export
    user = User.find(params[:user_id])
    tasks = user
      .tasks
      .between_dates(params[:start_date], params[:end_date])
      .order(:date, :id)

    date_range = "#{params[:start_date]} - #{params[:end_date]}"

    content = ExportService::Task.export tasks, date_range, user

    render html: content.html_safe
  end

  private

  def authorise_user!
    unless current_user.admin?
      respond_with_custom_error 'Current user is not authorised to use this endpoint', 403
    end
  end

  def validate_user_filter
    if params[:user_id].blank?
      respond_with_custom_error 'user_id is required', 422
    end
  end
end
