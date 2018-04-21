class Api::SessionsController < Devise::SessionsController
  def create
    user = warden.authenticate!(auth_options)
    token = Tiddle.create_and_return_token(user, request)
    render json: { email: user.email, token: token }, status: 201
  end

  def destroy
    Tiddle.expire_token(current_user, request) if current_user
    head 204
  end

  private

    # this is invoked before destroy and we have to override it
    def verify_signed_out_user
    end
end
