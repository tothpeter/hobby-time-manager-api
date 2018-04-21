class Api::BaseController < ActionController::API
  include CanCan::ControllerAdditions
  include JSONAPI::ActsAsResourceController

  rescue_from CanCan::AccessDenied do |exception|
    action = exception.action
    resource = exception.subject.class

    respond_with_custom_error "You are not authorized to perform #{action} on #{resource}", 403
  end

  def context
    {
      current_user: current_user,
      params: params
    }
  end

  protected

  def respond_with_errors object
    render json: { errors: ErrorSerializer.serialize(object) }, status: :unprocessable_entity
  end

  def respond_with_custom_error title, status
    error = {
      errors: [
        {
          title:  title,
          status: status
        }
      ]
    }

    render json: error, status: status
  end

end
