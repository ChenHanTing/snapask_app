class UsersController < ApplicationController
  before_action :is_admin
  before_action :set_user, only: %i(edit update destroy)

  def index
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = '更新成功'
    else
      flash[:alert] = '更新失敗'
    end

    redirect_to users_path
  end

  private

  def is_admin
    redirect_to :root unless current_user&.super_admin?
  end

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit( :email, :password, :role)
  end
end
