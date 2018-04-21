module TasksControllerConcern
  def validate_date_filter
    if params[:start_date].blank? || params[:end_date].blank?
      return respond_with_custom_error 'start_date or end_date is missing', 422
    end

    begin
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
    rescue
      return respond_with_custom_error 'invalid start or end date', 422
    end

    if (end_date - start_date) > 92
      return respond_with_custom_error 'the max time gap between start_date and end_date is 3 months', 422
    end
  end
end
