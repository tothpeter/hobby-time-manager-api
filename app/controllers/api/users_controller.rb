class Api::UsersController < Api::BaseController
  include JSONAPI::ActsAsResourceController

  before_action :authenticate_user!, except: :create
  before_action :set_user, only: [ :update, :password ]

  authorize_resource

  def me
    render json: current_user
  end

  def create
    @user = User.new(user_params)
    @user.skip_confirmation!
    assign_access_level

    if @user.save
      render json: @user, status: :created
    else
      respond_with_errors @user
    end
  end

  def update
    assign_access_level
    @user.skip_reconfirmation!

    if @user.update(user_params_for_update)
      render json: @user
    else
      respond_with_errors @user
    end
  end

  def password
    if @user.update(password_params)
      head 204
    else
      respond_with_errors @user
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:data).require(:attributes).permit(:email, :password, :username, :first_name, :last_name, :preferred_working_hours_per_day)
    end

    def user_params_for_update
      params.require(:data).require(:attributes).permit(:email, :username, :first_name, :last_name, :preferred_working_hours_per_day)
    end

    def password_params
      params.permit(:password)
    end

    def assign_access_level
      if current_user && current_user.admin?
        @user.access_level = params[:data][:attributes][:access_level]
      end
    end
end
