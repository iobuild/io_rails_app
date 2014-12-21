class Admin::UsersController < Admin::BaseController

  before_filter :pre_load

  def pre_load
    @user = User.find(params[:id]) if params[:id]
  end

  before_action :set_user, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  def user_params
    params.require(:user).permit(:username, :email, :avatar, :password, :nation, :residence, :created_at, :updated_at)
  end
  

  def index
    @users = User.search_and_order(params[:search])
  end
  
  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to "/admin/users"
    end
  end


  def update
    if @user.update_attributes(user_params)
      redirect_to "/admin/users"
    end
  end


  def destroy
    if @user.destroy
      redirect_to "/admin/users"
    end
  end
  
end
