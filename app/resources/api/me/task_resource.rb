class Api::Me::TaskResource < Api::TaskResource
  def self.records options = {}
    params = options[:context][:params]
    scope = options[:context][:current_user].tasks

    if params[:start_date].present?
      scope = scope.between_dates(params[:start_date], params[:end_date])
    end

    scope
  end

  before_save do
    @model.user_id = context[:current_user].id
    @model.description = ActionView::Base.full_sanitizer.sanitize(@model.description)
    @model.title = ActionView::Base.full_sanitizer.sanitize(@model.title)
  end

  def self.resource_for type
    if type.downcase.include? 'user'
      Api::UserResource
    else
      super type
    end
  end
end
